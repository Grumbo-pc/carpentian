#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== ubiquity-casper file list ==="
dpkg -L ubiquity-casper
echo "=== tree of /usr/share/ubiquity ==="
find /usr/share/ubiquity -maxdepth 2 | sort | head -40
echo "=== casper-bottom dir in initramfs-tools ==="
ls /usr/share/initramfs-tools/scripts/casper-bottom/ 2>/dev/null | head
grep -l "ubiquity" /usr/share/initramfs-tools/scripts/casper-bottom/* 2>/dev/null
'