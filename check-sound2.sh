#!/bin/bash
set -e

# Check dconf for sound-theme
echo "=== dconf sound-theme ==="
grep -r "sound-theme" /root/carpentian-build/chroot/etc/dconf/ 2>/dev/null
grep -r "sound-theme" /root/carpentian-build/chroot/usr/share/glib-2.0/schemas/ 2>/dev/null

echo "=== 01-carpentian full ==="
cat /root/carpentian-build/chroot/etc/dconf/db/local.d/01-carpentian

echo "=== checking gschema override ==="
grep -r "sound" /root/carpentian-build/chroot/usr/share/glib-2.0/schemas/*.override 2>/dev/null
