#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== ubiquity.service enable symlinks ==="
ls -la /etc/systemd/system/graphical.target.wants/ 2>/dev/null | grep -i ubiquity
ls -la /etc/systemd/system/*.wants/*ubiquity* 2>/dev/null
echo "=== get_casper in ubiquity.casper ==="
grep -n "def get_casper" -A 15 /usr/lib/ubiquity/ubiquity/casper.py
echo "=== check initrd generation picked up casper scripts (rebuild) ==="
unmkinitramfs /boot/initrd.img-$(ls /boot/vmlinuz-*-generic | sed "s|.*vmlinuz-||") out-verify 2>/dev/null || (mkdir -p out-verify && cd out-verify && cpio -idmu < <(unmkinitramfs /boot/initrd.img-6.8.0-138-generic /tmp/q 2>/dev/null || echo))
ls /boot/initrd.img-*-generic
'