#!/bin/bash
set -ex
cd ~/carpentian-build

WORK=/tmp/iso-build
ISO=/root/carpentian-build/Carpentian-OS.iso
CHROOT=/root/carpentian-build/chroot
IMAGE=/root/carpentian-build/image
KVER=$(ls "$CHROOT/boot/vmlinuz-"*-generic | sed "s|.*/vmlinuz-||;s|-generic||")

rm -rf $WORK
mkdir -p "$WORK/iso/casper"
mkdir -p "$WORK/iso/isolinux"
mkdir -p "$WORK/iso/boot/grub"
mkdir -p "$WORK/iso/EFI/boot"

# Rebuild squashfs fresh (delete stale layers before noappend)
rm -f "$IMAGE/casper/filesystem.squashfs"
mkdir -p "$IMAGE/casper"
mksquashfs "$CHROOT" "$IMAGE/casper/filesystem.squashfs" -comp xz -b 1M -noappend

# Only copy exactly what we need
cp "$IMAGE/casper/filesystem.squashfs" "$WORK/iso/casper/"
cp "$CHROOT/boot/vmlinuz-$KVER-generic" "$WORK/iso/casper/vmlinuz"
cp "$CHROOT/boot/initrd.img-$KVER-generic" "$WORK/iso/casper/initrd.img"

# Manifest
chroot "$CHROOT" dpkg-query -W --showformat='${Package} ${Version}\n' > "$WORK/iso/casper/filesystem.manifest"
cp "$WORK/iso/casper/filesystem.manifest" "$WORK/iso/casper/filesystem.manifest-remove"
for pkg in linux-image-$KVER-generic linux-headers-$KVER-generic; do
    echo "$pkg" >> "$WORK/iso/casper/filesystem.manifest-remove"
done

# ISOLINUX for BIOS boot
cp /usr/lib/ISOLINUX/isolinux.bin "$WORK/iso/isolinux/"
cp /usr/lib/ISOLINUX/isohdpfx.bin "$WORK/iso/isolinux/"
cp /usr/lib/syslinux/modules/bios/ldlinux.c32 "$WORK/iso/isolinux/"
cp /usr/lib/syslinux/modules/bios/libcom32.c32 "$WORK/iso/isolinux/"
cp /usr/lib/syslinux/modules/bios/libutil.c32 "$WORK/iso/isolinux/"
cp /usr/lib/syslinux/modules/bios/menu.c32 "$WORK/iso/isolinux/"
cp /usr/lib/syslinux/modules/bios/vesamenu.c32 "$WORK/iso/isolinux/"
cp /usr/lib/syslinux/modules/bios/chain.c32 "$WORK/iso/isolinux/"

cat > "$WORK/iso/isolinux/isolinux.cfg" << 'ISOCFG'
DEFAULT live
TIMEOUT 50
UI vesamenu.c32
MENU TITLE Carpentian
LABEL live
  MENU LABEL ^Try Carpentian
  LINUX /casper/vmlinuz
  INITRD /casper/initrd.img
  APPEND boot=casper quiet splash
LABEL live-nomodeset
  MENU LABEL Try Carpentian (^safe graphics)
  LINUX /casper/vmlinuz
  INITRD /casper/initrd.img
  APPEND boot=casper nomodeset quiet splash
LABEL live-install
  MENU LABEL ^Install Carpentian
  LINUX /casper/vmlinuz
  INITRD /casper/initrd.img
  APPEND boot=casper only-ubiquity quiet splash noprompt cdrom-detect/try-usb=true
ISOCFG

# GRUB for EFI boot
cat > "$WORK/iso/boot/grub/grub.cfg" << 'GRUBCFG'
set default=0
set timeout=5
insmod all_video
insmod gfxterm
terminal_output gfxterm

menuentry "Try Carpentian" {
    linux /casper/vmlinuz boot=casper quiet splash
    initrd /casper/initrd.img
}
menuentry "Try Carpentian (safe graphics)" {
    linux /casper/vmlinuz boot=casper nomodeset quiet splash
    initrd /casper/initrd.img
}
menuentry "Install Carpentian" {
    linux /casper/vmlinuz boot=casper only-ubiquity quiet splash noprompt cdrom-detect/try-usb=true
    initrd /casper/initrd.img
}
GRUBCFG

# Create GRUB standalone EFI image
grub-mkstandalone --format=x86_64-efi --output="$WORK/efi.img" --locales="" --fonts="" "boot/grub/grub.cfg=$WORK/iso/boot/grub/grub.cfg"

# Create ESP image
dd if=/dev/zero of="$WORK/esp.img" bs=1M count=10
mkfs.vfat "$WORK/esp.img"
mkdir -p "$WORK/esp-mount"
mount -o loop "$WORK/esp.img" "$WORK/esp-mount"
mkdir -p "$WORK/esp-mount/EFI/BOOT"
cp "$WORK/efi.img" "$WORK/esp-mount/EFI/BOOT/bootx64.efi"
umount "$WORK/esp-mount"
cp "$WORK/esp.img" "$WORK/iso/efi.img"

# Copy EFI grub config for legacy EFI fallback
cp "$WORK/iso/boot/grub/grub.cfg" "$WORK/iso/EFI/boot/grub.cfg"

# Disk info
cat > "$WORK/iso/README.diskdefines" << EOF
#define DISKNAME  Carpentian
#define TYPE  binary
#define ARCH  amd64
EOF
# .disk metadata required for ubiquity branding + casper RELEASE substitution
mkdir -p "$WORK/iso/.disk"
echo -n "Carpentian 1.0" > "$WORK/iso/.disk/info"
echo -n "test" > "$WORK/iso/.disk/base_installable"
echo "full_cd/single" > "$WORK/iso/.disk/cd_type"
echo -n "carpentian" > "$WORK/iso/.disk/live-uuid-generic"
echo -n "carpentian" > "$WORK/iso/.disk/live-uuid-ignore-device"

# Build ISO
xorriso -as mkisofs \
    -r -J \
    -joliet-long \
    -volid "CARPENTIAN" \
    -o "$ISO" \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -c isolinux/boot.cat \
    -eltorito-boot isolinux/isolinux.bin \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
    -eltorito-alt-boot \
        -e efi.img \
        -no-emul-boot \
        -isohybrid-gpt-basdat \
    "$WORK/iso"

echo ""
echo "=== ISO created ==="
ls -lh "$ISO"
cp "$ISO" /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/Carpentian-OS.iso
echo "=== COPIED TO WINDOWS ==="
ls -lh /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/Carpentian-OS.iso
echo "=== DONE ==="
