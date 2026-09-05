#!/bin/bash
# Build bootable Carpentian OS ISO v8
# Step 1: lb build with grub-efi for base contents
# Step 2: Custom script adds BIOS boot (isolinux) with correct INITRD
set -ex

cd ~/carpentian-build

# Step 1: Set up for EFI build (which works)
cat > config/binary << 'EOF'
LB_BINARY_FILESYSTEM="fat16"
LB_BINARY_IMAGES="iso"
LB_APT_INDICES="true"
LB_BOOTAPPEND_LIVE="boot=live components quiet splash ramdisk-size=1024"
LB_BOOTAPPEND_INSTALL=""
LB_BOOTAPPEND_FAILSAFE="memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash vga=normal"
LB_BOOTLOADER="grub-efi"
LB_CHECKSUMS="md5"
LB_COMPRESSION="xz"
LB_ZSYNC="true"
LB_BUILD_WITH_CHROOT="true"
LB_DEBIAN_INSTALLER="false"
LB_GRUB_SPLASH=""
LB_HDD_LABEL="UBUNTU"
LB_HDD_SIZE="10000"
LB_ISO_APPLICATION="Carpentian OS"
LB_ISO_PREPARER="Carpentian OS Build"
LB_ISO_PUBLISHER="Carpentian OS"
LB_ISO_VOLUME="Carpentian OS"
EOF

# Rebuild chroot to restore packages
lb clean 2>&1 | tail -3
lb build 2>&1 | tail -20

echo "=== lb build done, checking output ==="
ls -la binary/casper/ 2>/dev/null
ls -la binary/.disk/ 2>/dev/null

# Step 2: Post-process to add BIOS boot with correct INITRD
echo "=== Adding BIOS boot support ==="
WORK="/tmp/iso-build"
ISO="/root/carpentian-build/Carpentian-OS.iso"
rm -rf "$WORK"
mkdir -p "$WORK/iso"

cp -r binary/* "$WORK/iso/"
cp -r binary/.disk "$WORK/iso/" 2>/dev/null || true

# Copy kernel/initrd from chroot (fresh copies, no symlinks)
cp chroot/boot/vmlinuz-6.8.0-138-generic "$WORK/iso/casper/vmlinuz"
cp chroot/boot/initrd.img-6.8.0-138-generic "$WORK/iso/casper/initrd.img"

# Setup isolinux for BIOS boot
mkdir -p "$WORK/iso/isolinux"
cp /usr/lib/ISOLINUX/isolinux.bin "$WORK/iso/isolinux/"
cp /usr/lib/ISOLINUX/isohdpfx.bin "$WORK/iso/isolinux/"
cp /usr/lib/syslinux/modules/bios/ldlinux.c32 "$WORK/iso/isolinux/" 2>/dev/null || true
cp /usr/lib/syslinux/modules/bios/libcom32.c32 "$WORK/iso/isolinux/" 2>/dev/null || true
cp /usr/lib/syslinux/modules/bios/libutil.c32 "$WORK/iso/isolinux/" 2>/dev/null || true
cp /usr/lib/syslinux/modules/bios/menu.c32 "$WORK/iso/isolinux/" 2>/dev/null || true
cp /usr/lib/syslinux/modules/bios/vesamenu.c32 "$WORK/iso/isolinux/" 2>/dev/null || true
cp /usr/lib/syslinux/modules/bios/chain.c32 "$WORK/iso/isolinux/" 2>/dev/null || true

cat > "$WORK/iso/isolinux/isolinux.cfg" << 'ISOCFG'
UI vesamenu.c32
MENU TITLE Carpentian OS Boot Menu
DEFAULT live
TIMEOUT 100

LABEL live
    MENU LABEL ^Try Carpentian OS Without Installing
    SAY Booting Carpentian OS...
    LINUX /casper/vmlinuz
    INITRD /casper/initrd.img
    APPEND boot=live components quiet splash ramdisk-size=1024

LABEL live-nomodeset
    MENU LABEL Try Carpentian OS (Safe Graphics)
    SAY Booting with safe graphics...
    LINUX /casper/vmlinuz
    INITRD /casper/initrd.img
    APPEND boot=live components nomodeset ramdisk-size=1024

LABEL live-debug
    MENU LABEL Debug Shell (for troubleshooting)
    SAY Booting debug shell...
    LINUX /casper/vmlinuz
    INITRD /casper/initrd.img
    APPEND boot=live components debug BOOT_DEBUG=1 ramdisk-size=1024

LABEL live-install
    MENU LABEL ^Install Carpentian OS
    SAY Starting installer...
    LINUX /casper/vmlinuz
    INITRD /casper/initrd.img
    APPEND boot=live components quiet splash ramdisk-size=1024
ISOCFG

# Build ISO with both BIOS and EFI boot
# Build ISO with both BIOS and EFI boot
echo "Creating GRUB EFI image for EFI boot..."
mkdir -p "$WORK/iso/boot/grub"
cat > "$WORK/iso/boot/grub/grub.cfg" << 'GRUBCFG'
set default=0
set timeout=5
insmod all_video
insmod gfxterm
terminal_output gfxterm

menuentry "Carpentian OS - Try Without Installing" {
    linux /casper/vmlinuz boot=live components quiet splash ramdisk-size=1024
    initrd /casper/initrd.img
}

menuentry "Carpentian OS - Safe Graphics" {
    linux /casper/vmlinuz boot=live components nomodeset ramdisk-size=1024
    initrd /casper/initrd.img
}

menuentry "Carpentian OS - Install" {
    linux /casper/vmlinuz boot=live components quiet splash ramdisk-size=1024
    initrd /casper/initrd.img
}
GRUBCFG

grub-mkstandalone \
    --format=x86_64-efi \
    --output="$WORK/efi.img" \
    --locales="" \
    --fonts="" \
    "boot/grub/grub.cfg=$WORK/iso/boot/grub/grub.cfg"

dd if=/dev/zero of="$WORK/esp.img" bs=1M count=10
mkfs.vfat "$WORK/esp.img"
mkdir -p "$WORK/esp-mount"
mount -o loop "$WORK/esp.img" "$WORK/esp-mount"
mkdir -p "$WORK/esp-mount/EFI/BOOT"
cp "$WORK/efi.img" "$WORK/esp-mount/EFI/BOOT/bootx64.efi"
umount "$WORK/esp-mount"
cp "$WORK/esp.img" "$WORK/iso/efi.img"

echo "Building final ISO..."
xorriso -as mkisofs \
    -r -J \
    -joliet-long \
    -V "Carpentian OS" \
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

cp "$ISO" /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/Carpentian-OS.iso
ls -lh /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/Carpentian-OS.iso
echo "=== DONE ==="
