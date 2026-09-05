#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== systemd units mentioning ubiquity ==="
grep -rln "ubiquity" /usr/lib/systemd/system/ /lib/systemd/system/ /etc/systemd/system/ 2>/dev/null
echo "=== dpkg -L ubiquity systemd ==="
dpkg -L ubiquity | grep -iE "systemd|\.service" 
echo "=== casper-bottom hooks for ubiquity in initramfs-tools ==="
grep -rln "only-ubiquity" /usr/share/initramfs-tools/ 2>/dev/null
'