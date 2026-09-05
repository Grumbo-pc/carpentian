#!/bin/bash
# Create bootable Carpentian OS ISO with proper GRUB EFI boot
set -e

BINARY_DIR="/root/carpentian-build/binary"
BUILD_DIR="/root/carpentian-build"
ISO_NAME="/root/carpentian-build/Carpentian-OS.iso"
WORK="/tmp/iso-work"

echo "=== Creating bootable Carpentian OS ISO ==="

# Clean work dir
rm -rf "$WORK"
mkdir -p "$WORK/iso" "$WORK/efi" "$WORK/boot/grub"

# Copy all binary contents
cp -r "$BINARY_DIR"/* "$WORK/iso/"

# Create GRUB EFI config
cat > "$WORK/boot/grub/grub.cfg" << 'GRUBCFG'
set default=0
set timeout=3

insmod all_video
insmod gfxterm

terminal_output gfxterm

menuentry "Carpentian OS - Try Without Installing" {
    linux /casper/vmlinuz boot=live components quiet splash ramdisk-size=1024
    initrd /casper/initrd.img
}

menuentry "Carpentian OS - Try Without Installing (Safe Graphics)" {
    linux /casper/vmlinuz boot=live components quiet splash nomodeset
    initrd /casper/initrd.img
}

menuentry "Carpentian OS - Install to Hard Drive" {
    linux /casper/vmlinuz boot=live components quiet splash ramdisk-size=1024 ---
    initrd /casper/initrd.img
}

menuentry "Carpentian OS - Check Disk for Defects" {
    linux /casper/vmlinuz boot=live components quiet splash integrity-check
    initrd /casper/initrd.img
}

menuentry "Memory Test" {
    linux /casper/memtest
}
GRUBCFG

# Create GRUB standalone EFI image
echo "Creating GRUB EFI image..."
grub-mkstandalone \
    --format=x86_64-efi \
    --output="$WORK/boot/grub/efi.img" \
    --locales="" \
    --fonts="" \
    "boot/grub/grub.cfg=$WORK/boot/grub/grub.cfg"

# Create ESP (EFI System Partition) image
echo "Creating EFI System Partition..."
dd if=/dev/zero of="$WORK/efi.img" bs=1M count=10
mkfs.vfat "$WORK/efi.img"
mkdir -p "$WORK/efi-mount"
mount -o loop "$WORK/efi.img" "$WORK/efi-mount"
mkdir -p "$WORK/efi-mount/EFI/BOOT"
cp "$WORK/boot/grub/efi.img" "$WORK/efi-mount/EFI/BOOT/bootx64.efi"
umount "$WORK/efi-mount"

# Create BIOS boot image with isolinux for legacy BIOS support
echo "Creating BIOS boot image..."
apt-get install -y isolinux syslinux-common 2>/dev/null || true
if [ -f /usr/lib/ISOLINUX/isohdpfx.bin ]; then
    BIOS_BOOT="/usr/lib/ISOLINUX/isohdpfx.bin"
elif [ -f /usr/lib/syslinux/bios/isohdpfx.bin ]; then
    BIOS_BOOT="/usr/lib/syslinux/bios/isohdpfx.bin"
else
    BIOS_BOOT=""
fi

# Create the final ISO with xorriso
echo "Building final ISO with boot records..."
if [ -n "$BIOS_BOOT" ]; then
    xorriso -as mkisofs \
        -r -J \
        -joliet-long \
        -V "Carpentian OS" \
        -o "$ISO_NAME" \
        -isohybrid-mbr "$BIOS_BOOT" \
        -c boot.cat \
        -eltorito-boot isolinux/bios.img \
            -no-emul-boot \
            -boot-load-size 4 \
            -boot-info-table \
            --eltorito-catalog boot/grub/boot.cat \
        -eltorito-alt-boot \
            -e boot/grub/efi.img \
            -no-emul-boot \
            -isohybrid-gpt-basdat \
        "$WORK/iso"
else
    # EFI-only boot (no BIOS)
    xorriso -as mkisofs \
        -r -J \
        -joliet-long \
        -V "Carpentian OS" \
        -o "$ISO_NAME" \
        -eltorito-boot boot/grub/efi.img \
            -no-emul-boot \
            -isohybrid-gpt-basdat \
        "$WORK/iso"
fi

echo ""
echo "=== ISO created ==="
ls -lh "$ISO_NAME"
echo ""
echo "To copy to Windows:"
echo "  cp $ISO_NAME '/mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/Carpentian-OS.iso'"
