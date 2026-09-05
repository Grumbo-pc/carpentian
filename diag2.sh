#!/bin/bash
C=/root/carpentian-build/chroot
echo "=== unsquashfs proper: list graphical.target.wants inside squashfs ==="
rm -rf /tmp/sq2 && mkdir -p /tmp/sq2 && cd /tmp/sq2
unsquashfs -no-progress /root/carpentian-build/image/casper/filesystem.squashfs etc/systemd/system/graphical.target.wants etc/systemd/system 2>&1 | tail -3
echo "--- wants contents ---"
ls -la /tmp/sq2/squashfs-root/etc/systemd/system/graphical.target.wants/ 2>/dev/null
echo "--- systemd/system symlinks matching ---"
ls -la /tmp/sq2/squashfs-root/etc/systemd/system/ 2>/dev/null | grep -i ubiquity
echo "=== stock ubiquity.service ==="
cat /tmp/sq2/squashfs-root/etc/systemd/system/graphical.target.wants/ubiquity.service 2>/dev/null
echo "=== lightdm alias for display-manager ==="
grep -n "Alias=\|WantedBy\|[Install]" $C/usr/lib/systemd/system/lightdm.service 2>/dev/null
cat $C/usr/lib/systemd/system/lightdm.service 2>/dev/null | grep -A3 Install
echo "=== does display-manager.service exist? ==="
ls -la $C/etc/systemd/system/display-manager.service $C/lib/systemd/system/display-manager.service 2>/dev/null
echo "=== ubiquity-dm checks: does it need xhost/consolekit? grep for DISPLAY init ==="
grep -n "Xorg\|X :0\|xinit\|startx\|XDG\|gtk_ui\|--only" $C/usr/bin/ubiquity-dm | head