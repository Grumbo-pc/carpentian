#!/bin/bash
C=/root/carpentian-build/chroot
echo "=== modules dir ==="
ls "$C/lib/modules/" 2>/dev/null
echo "=== chroot mounts ==="
cat /proc/mounts | grep carpentian
echo "=== MODULES setting ==="
cat "$C/etc/initramfs-tools/initramfs.conf"