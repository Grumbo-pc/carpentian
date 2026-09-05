#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

# Check how Cinnamon manages panel layout
echo "=== Panel JS check ==="
grep -n "enabled-applets\|panel_list\|layout" "$CHROOT/usr/share/cinnamon/js/ui/panel.js" 2>/dev/null | head -10

echo "=== Applet Manager check ==="
grep -n "enabled-applets\|get_strv" "$CHROOT/usr/share/cinnamon/js/ui/appletManager.js" 2>/dev/null | head -10

echo "=== Cinnamon 6 layout files ==="
find "$CHROOT/usr/share/cinnamon" -name "layout*" -not -path "*/node_modules/*" 2>/dev/null | head -10

echo "=== Checking user .cinnamon ==="
ls -la "$CHROOT/home/carpentian/.cinnamon/" 2>/dev/null

echo "=== Stale panel config? ==="
find "$CHROOT/home/carpentian/.cinnamon" -name "*.json" 2>/dev/null

echo "=== Cinnamon panel default layout ==="
find "$CHROOT/usr/share/cinnamon" -name "cinnamon-layout" -o -name "*.layout" 2>/dev/null | head -10
