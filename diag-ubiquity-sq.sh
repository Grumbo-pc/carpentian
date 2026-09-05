#!/bin/bash
C=/root/carpentian-build/chroot
echo "=== enable symlink in chroot ==="
ls -la $C/etc/systemd/system/graphical.target.wants/ 2>/dev/null
echo "=== symlink inside squashfs? extract and check ==="
rm -rf /tmp/sq-check && mkdir -p /tmp/sq-check
cd /tmp/sq-check
unsquashfs -no-progress -f /root/carpentian-build/image/casper/filesystem.squashfs "etc/systemd/system/graphical.target.wants" "usr/lib/systemd/system/ubiquity.service" "usr/share/ubiquity/start-ubiquity-dm" 2>&1 | tail -3
echo "--- extracted ---"
ls -la /tmp/sq-check/squashfs-root/etc/systemd/system/graphical.target.wants/ 2>/dev/null
echo "=== is ubiquity.service referenced? ==="
grep -l "ubiquity" /tmp/sq-check/squashfs-root/etc/systemd/system/graphical.target.wants/* 2>/dev/null
echo "=== lightdm alias display-manager? ==="
grep -rn "Alias=display-manager\|WantedBy" $C/lib/systemd/system/lightdm.service 2>/dev/null
$C/usr/bin/systemctl 2>/dev/null; ls $C/etc/systemd/system/*.service 2>/dev/null | head
echo "=== start-ubiquity-dm present in squashfs? ==="
ls -la /tmp/sq-check/squashfs-root/usr/share/ubiquity/start-ubiquity-dm 2>/dev/null || echo "NOT HERE"