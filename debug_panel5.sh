#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

echo "=== PanelManager init ==="
grep -n "panels-enabled\|enabled-applets\|_init\|addPanel\|updatePanels\|_loadPanel" "$CHROOT/usr/share/cinnamon/js/ui/panel.js" 2>/dev/null | head -30

echo "=== panels-enabled key ==="
grep -n "panels-enabled" "$CHROOT/usr/share/cinnamon/js/ui/panel.js" 2>/dev/null | head -10

echo "=== How does panel know its position ==="
grep -n "panelPosition\|_position\|LEFT\|CENTER\|RIGHT" "$CHROOT/usr/share/cinnamon/js/ui/panel.js" 2>/dev/null | head -20
