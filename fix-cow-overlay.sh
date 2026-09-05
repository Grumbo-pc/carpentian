#!/bin/bash
# ================================================================
# fix-cow-overlay.sh  —  Carpentian OS boot freeze fix
# Error: "/cow format specified as 'overlay' and no support found"
#
# ROOT CAUSE: live-boot and casper are BOTH installed in the chroot.
# They conflict. live-boot installs its own initramfs hooks that
# override casper's overlay setup, breaking the /cow mount.
#
# Run this script inside WSL as root:
#   sudo bash /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/fix-cow-overlay.sh
# ================================================================
set -e

# ── Config ────────────────────────────────────────────────────
# The script auto-detects which build dir to use.
for candidate in /root/carpentian-build /root/carpentian-build-v2; do
    if [ -d "$candidate/chroot/etc/apt" ]; then
        BUILD_DIR="$candidate"
        break
    fi
done
if [ -z "$BUILD_DIR" ]; then
    echo "ERROR: No chroot found. Set BUILD_DIR manually."
    exit 1
fi

CHROOT="$BUILD_DIR/chroot"
IMAGE="$BUILD_DIR/image"
ISO_OUT="/mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/Carpentian-OS.iso"

echo "================================================================"
echo "  Carpentian OS — Overlay Boot Fix"
echo "  Build dir: $BUILD_DIR"
echo "================================================================"

# ── Mount chroot ──────────────────────────────────────────────
echo ""
echo "==> Mounting chroot filesystems..."
mount --bind /dev     "$CHROOT/dev"     2>/dev/null || true
mount --bind /dev/pts "$CHROOT/dev/pts" 2>/dev/null || true
mount -t proc  proc   "$CHROOT/proc"    2>/dev/null || true
mount -t sysfs sysfs  "$CHROOT/sys"     2>/dev/null || true
mount -t tmpfs tmpfs  "$CHROOT/run"     2>/dev/null || true
cp /etc/resolv.conf "$CHROOT/etc/resolv.conf" 2>/dev/null || true

cleanup() {
    echo "Unmounting chroot..."
    umount "$CHROOT/run"     2>/dev/null || true
    umount "$CHROOT/dev/pts" 2>/dev/null || true
    umount "$CHROOT/sys"     2>/dev/null || true
    umount "$CHROOT/proc"    2>/dev/null || true
    umount "$CHROOT/dev"     2>/dev/null || true
}
trap cleanup EXIT

# ── FIX 1: Remove live-boot (it conflicts with casper) ────────
echo ""
echo "==> FIX 1: Removing live-boot (conflicts with casper)..."
DEBIAN_FRONTEND=noninteractive chroot "$CHROOT" apt-get remove -y \
    live-boot \
    live-boot-initramfs-tools \
    live-config \
    live-config-systemd \
    2>/dev/null || true
DEBIAN_FRONTEND=noninteractive chroot "$CHROOT" apt-get autoremove -y 2>/dev/null || true
echo "    live-boot removed."

# Verify live-boot is gone
if chroot "$CHROOT" dpkg -l live-boot 2>/dev/null | grep -q "^ii"; then
    echo "    WARNING: live-boot still shows as installed. Purging..."
    DEBIAN_FRONTEND=noninteractive chroot "$CHROOT" dpkg --purge live-boot live-boot-initramfs-tools 2>/dev/null || true
fi

# ── FIX 2: Ensure casper is properly installed ────────────────
echo ""
echo "==> FIX 2: Ensuring casper is installed..."
DEBIAN_FRONTEND=noninteractive chroot "$CHROOT" apt-get update -qq
DEBIAN_FRONTEND=noninteractive chroot "$CHROOT" apt-get install -y --reinstall casper
echo "    casper reinstalled."

# Verify casper hook exists
if [ ! -f "$CHROOT/usr/share/initramfs-tools/hooks/casper" ]; then
    echo "ERROR: casper initramfs hook still missing after reinstall!"
    exit 1
fi
echo "    casper hook: OK"

# ── FIX 3: Remove lupin-casper (Wubi remnant, broken on Noble) 
echo ""
echo "==> FIX 3: Removing lupin-casper if present..."
DEBIAN_FRONTEND=noninteractive chroot "$CHROOT" apt-get remove -y lupin-casper 2>/dev/null || true

# ── FIX 4: Add overlay/squashfs/loop to initramfs modules ─────
echo ""
echo "==> FIX 4: Adding overlay module to initramfs-tools..."
MODULES_FILE="$CHROOT/etc/initramfs-tools/modules"
for mod in overlay squashfs loop; do
    if ! grep -q "^$mod" "$MODULES_FILE" 2>/dev/null; then
        echo "$mod" >> "$MODULES_FILE"
        echo "    Added: $mod"
    else
        echo "    Already present: $mod"
    fi
done

# ── FIX 5: Detect kernel version ─────────────────────────────
echo ""
echo "==> FIX 5: Detecting kernel version..."
KVER=$(ls "$CHROOT/boot/vmlinuz-"*-generic 2>/dev/null \
       | sed 's|.*/vmlinuz-||' \
       | sort -V \
       | tail -1)
if [ -z "$KVER" ]; then
    echo "ERROR: No kernel found in $CHROOT/boot/"
    exit 1
fi
echo "    Kernel: $KVER"

# ── FIX 6: Rebuild initramfs ──────────────────────────────────
echo ""
echo "==> FIX 6: Rebuilding initramfs..."
chroot "$CHROOT" update-initramfs -u -k "$KVER" 2>&1
echo "    Initramfs rebuilt."

# ── Verify overlay is in the new initrd ──────────────────────
echo ""
echo "==> Verifying overlay module in new initrd..."
INITRD="$CHROOT/boot/initrd.img-$KVER"

# Check for live-boot hooks (should be gone)
if lsinitramfs "$INITRD" 2>/dev/null | grep -q "live-boot\|9990-overlay"; then
    echo "    WARNING: live-boot hooks still found in initrd! Something is wrong."
else
    echo "    OK: No live-boot hooks in initrd."
fi

# Check for overlay module
if lsinitramfs "$INITRD" 2>/dev/null | grep -q "overlayfs/overlay"; then
    echo "    OK: overlay.ko.zst found in initrd."
else
    echo "    WARNING: overlay module not found in initrd."
fi

# Check casper scripts
CASPER_COUNT=$(lsinitramfs "$INITRD" 2>/dev/null | grep -c "scripts/casper" || true)
echo "    Casper scripts in initrd: $CASPER_COUNT"

# ── Copy fixed initrd to image dir ────────────────────────────
echo ""
echo "==> Copying fixed kernel + initrd to image/casper/..."
mkdir -p "$IMAGE/casper"
cp "$CHROOT/boot/vmlinuz-$KVER" "$IMAGE/casper/vmlinuz"
cp "$CHROOT/boot/initrd.img-$KVER" "$IMAGE/casper/initrd.img"
echo "    vmlinuz: $(du -h $IMAGE/casper/vmlinuz | cut -f1)"
echo "    initrd:  $(du -h $IMAGE/casper/initrd.img | cut -f1)"

# ── Rebuild squashfs ──────────────────────────────────────────
echo ""
echo "==> Rebuilding squashfs (this will take several minutes)..."
rm -f "$IMAGE/casper/filesystem.squashfs"
mksquashfs "$CHROOT" "$IMAGE/casper/filesystem.squashfs" \
    -noappend -no-duplicates -no-recovery \
    -wildcards \
    -comp xz -b 1M -Xdict-size 100% \
    -e "var/cache/apt/archives/*" \
    -e "root/*" -e "root/.*" \
    -e "tmp/*" -e "tmp/.*" \
    -e "swapfile" \
    -e "proc/*" -e "sys/*" \
    -e "dev/*" -e "run/*" \
    -e "media/*" -e "mnt/*" -e "cdrom/*"

printf $(du -sx --block-size=1 "$CHROOT" | cut -f1) > "$IMAGE/casper/filesystem.size"
echo "    squashfs: $(du -h $IMAGE/casper/filesystem.squashfs | cut -f1)"

# ── Rebuild ISO ───────────────────────────────────────────────
echo ""
echo "==> Rebuilding ISO..."

# Get grub config location
GRUB_CFG=""
for f in "$IMAGE/boot/grub/grub.cfg" "$IMAGE/isolinux/grub.cfg"; do
    [ -f "$f" ] && GRUB_CFG="$f" && break
done
[ -z "$GRUB_CFG" ] && GRUB_CFG="$IMAGE/boot/grub/grub.cfg"
mkdir -p "$(dirname $GRUB_CFG)"

# Write a clean grub.cfg — using boot=casper (NOT boot=live)
cat > "$GRUB_CFG" << 'GRUBCFG'
set default=0
set timeout=10
insmod all_video
insmod gfxterm
terminal_output gfxterm

menuentry "Try Carpentian OS" {
    linux /casper/vmlinuz boot=casper quiet splash ---
    initrd /casper/initrd.img
}
menuentry "Try Carpentian OS (Safe Graphics)" {
    linux /casper/vmlinuz boot=casper nomodeset quiet splash ---
    initrd /casper/initrd.img
}
menuentry "Install Carpentian OS" {
    linux /casper/vmlinuz boot=casper only-ubiquity quiet splash ---
    initrd /casper/initrd.img
}
menuentry "Debug Shell" {
    linux /casper/vmlinuz boot=casper debug BOOT_DEBUG=3 ---
    initrd /casper/initrd.img
}
GRUBCFG

# Build GRUB standalone EFI image
WORK="$BUILD_DIR/iso-work"
rm -rf "$WORK"
mkdir -p "$WORK"

grub-mkstandalone \
    --format=x86_64-efi \
    --output="$WORK/bootx64.efi" \
    --locales="" --fonts="" \
    "boot/grub/grub.cfg=$GRUB_CFG"

# Create EFI partition image
dd if=/dev/zero of="$WORK/esp.img" bs=1M count=10 2>/dev/null
mkfs.vfat "$WORK/esp.img" >/dev/null
mkdir -p "$WORK/esp-mount"
mount -o loop "$WORK/esp.img" "$WORK/esp-mount"
mkdir -p "$WORK/esp-mount/EFI/BOOT"
cp "$WORK/bootx64.efi" "$WORK/esp-mount/EFI/BOOT/bootx64.efi"
umount "$WORK/esp-mount"

# Update md5sums
cd "$IMAGE"
find . -type f ! -path './isolinux/*' -print0 | xargs -0 md5sum > md5sum.txt 2>/dev/null || true

# Generate manifest
chroot "$CHROOT" dpkg-query -W --showformat='${Package} ${Version}\n' > "$IMAGE/casper/filesystem.manifest"

# Build ISO with BIOS + EFI support
ISO_TMP="$BUILD_DIR/Carpentian-OS.iso"
rm -f "$ISO_TMP"

xorriso -as mkisofs \
    -r -J -joliet-long \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "Carpentian OS" \
    -o "$ISO_TMP" \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -c isolinux/boot.cat \
    -b isolinux/isolinux.bin \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot \
    -e efi.img \
        -no-emul-boot \
        -isohybrid-gpt-basdat \
    "$IMAGE" \
    2>&1 | tail -5 || \
xorriso -as mkisofs \
    -r -J -joliet-long \
    -iso-level 3 \
    -volid "Carpentian OS" \
    -o "$ISO_TMP" \
    -eltorito-boot isolinux/bios.img \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        --eltorito-catalog boot.catalog \
        --grub2-boot-info \
        --grub2-mbr "$CHROOT/usr/lib/grub/i386-pc/boot_hybrid.img" \
        -partition_offset 16 \
        --mbr-force-bootable \
    -eltorito-alt-boot \
        -no-emul-boot \
        -e isolinux/efiboot.img \
        -append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b "$IMAGE/isolinux/efiboot.img" \
        -appended_part_as_gpt \
        -iso_mbr_part_type a2a0d0ebe5b9334487c068b6b72699c7 \
        -m "isolinux/efiboot.img" -m "isolinux/bios.img" \
        -e '--interval:appended_partition_2:::' \
    -exclude isolinux \
    -graft-points \
        "/EFI/boot/bootx64.efi=isolinux/bootx64.efi" \
        "/EFI/boot/grubx64.efi=isolinux/grubx64.efi" \
        "/EFI/ubuntu/grub.cfg=isolinux/grub.cfg" \
        "/isolinux/bios.img=isolinux/bios.img" \
        "/isolinux/efiboot.img=isolinux/efiboot.img" \
        "." \
    "$IMAGE" 2>&1 | tail -5

# Copy to Windows
cp "$ISO_TMP" "$ISO_OUT"
echo ""
echo "================================================================"
echo "  DONE! ISO written to:"
echo "  $ISO_OUT"
ls -lh "$ISO_OUT"
echo ""
echo "  Boot the ISO and select 'Try Carpentian OS'."
echo "  The overlay freeze should now be fixed."
echo "================================================================"
