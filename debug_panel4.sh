#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

echo "=== Check default layout in cinnamon ==="
grep -n "DEFAULT_PANEL\|defaultPanel\|_defaultLayout\|_initPanels\|panelDefinitions" "$CHROOT/usr/share/cinnamon/js/ui/layout.js" 2>/dev/null | head -20

echo "=== Check main.js ==="
grep -n "enabled-applets\|panel\|layout" "$CHROOT/usr/share/cinnamon/js/ui/main.js" 2>/dev/null | head -20

echo "=== Check session.js ==="
find "$CHROOT/usr/share/cinnamon/js/ui" -name "session*" 2>/dev/null

echo "=== How panels are created ==="
grep -n "addPanel\|_createPanel\|new Panel\|panelManager" "$CHROOT/usr/share/cinnamon/js/ui/layout.js" 2>/dev/null | head -20
