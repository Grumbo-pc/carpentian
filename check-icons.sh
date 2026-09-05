#!/bin/bash
IC=/root/carpentian-build/chroot/usr/share/icons/Carpentian-Gnome
echo "=== audio-volume-high-symbolic === "
grep -o 'fill="[^"]*"' $IC/symbolic/status/audio-volume-high-symbolic.svg | sort -u
echo "=== network-wireless good === "
grep -o 'fill="[^"]*"' $IC/symbolic/status/network-wireless-signal-good-symbolic.svg | sort -u
echo "=== gpm-battery/gpm-primary === "
grep -o 'fill="[^"]*"' $IC/symbolic/status/*battery*.svg 2>/dev/null | sort -u | head
echo "=== index.theme === "
grep -nE 'Name|Comment|Directories' $IC/index.theme | head
echo "=== power applet icon names ==="
ls $IC/symbolic/status/ | grep -iE 'power|bat' | head