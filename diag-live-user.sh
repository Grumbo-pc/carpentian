#!/bin/bash
C=/root/carpentian-build/chroot
echo "=== default runlevel target ==="
readlink $C/etc/systemd/system/default.target 2>/dev/null
echo "=== casper 25adduser: how is user created + password? ==="
sed -n '1,80p' $C/usr/share/initramfs-tools/scripts/casper-bottom/15autologin
echo "=== greeter 25adduser user add (chroot) ==="
grep -nE "useradd|chpasswd|passwd|usermod|casper-.*user|USERNAME|echo .*PW|^\s*PW" $C/usr/share/initramfs-tools/scripts/casper-bottom/25adduser 2>/dev/null | head -20