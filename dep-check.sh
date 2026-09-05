#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
apt-cache depends ubiquity 2>/dev/null | head -40
echo "=== grub-pc vs grub-efi-amd64 relation ==="
apt-cache depends grub-efi-amd64 2>/dev/null | grep -iE "conflict|replace|grub-pc"
echo "=== current grub state ==="
dpkg -l grub-pc grub-efi-amd64 2>/dev/null | grep ^i
'