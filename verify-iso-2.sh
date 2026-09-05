#!/bin/bash
set -e
M=/tmp/iso-mnt
mkdir -p $M
mount -o loop,ro /root/carpentian-build/Carpentian-OS.iso $M
echo "=== .disk/info ==="
cat $M/.disk/info
echo "=== grub.cfg Install entry ==="
grep -A2 'Install' $M/boot/grub/grub.cfg
echo "=== isolinux install label ==="
grep -A2 'Install' $M/isolinux/isolinux.cfg
echo "=== casper dir ==="
ls -la $M/casper/ | head
echo "=== ubiquity.desktop in squashfs via chroot ==="
ls -la /root/carpentian-build/chroot/usr/share/applications/ubiquity.desktop
umount $M
echo "=== DONE ==="