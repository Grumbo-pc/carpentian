#!/bin/bash
echo "=== search squashfs for ubiquity + graphical.target.wants ==="
unsquashfs -ll /root/carpentian-build/image/casper/filesystem.squashfs 2>/dev/null | grep -E "graphical.target.wants|ubiquity" | head -30
echo "=== lightdm default display manager ==="
cat /root/carpentian-build/chroot/etc/X11/default-display-manager 2>/dev/null
ls -la /root/carpentian-build/chroot/usr/sbin/lightdm 2>/dev/null