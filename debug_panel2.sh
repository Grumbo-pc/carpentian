#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

echo "=== How does Cinnamon read panel config? ==="
grep -n "enabled-applets\|_getPanelDefinitions\|panelDefinitions\|getDefaultPanel" "$CHROOT/usr/share/cinnamon/js/ui/appletManager.js" 2>/dev/null | head -20

echo "=== Panel layout in cinnamon-desktop ==="
grep -rn "panel-layout\|panel_list\|panel-layouts" "$CHROOT/usr/share/cinnamon/" 2>/dev/null | head -20

echo "=== Check cinnamon-settings-daemon ==="
chroot "$CHROOT" dpkg -l | grep cinnamon-settings-daemon 2>/dev/null | head -5

echo "=== Check for cinnamon-layout scripts ==="
find "$CHROOT/usr/share/cinnamon" -name "*layout*" -not -name "*.js" 2>/dev/null

echo "=== Check default panel config ==="
grep -rn "enabled-applets\|_panelDefault" "$CHROOT/usr/share/cinnamon/js/ui/" 2>/dev/null | head -20
