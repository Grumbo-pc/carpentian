#!/bin/bash
echo "=== Panel init / desktop-layout handling ==="
grep -n "desktop-layout\|_initDesktopLayout\|firstTimeSetup\|desktopLayout" /usr/share/cinnamon/js/ui/panel.js 2>/dev/null | head -30

echo ""
echo "=== Lines 140-200 (startup logic) ==="
sed -n '140,200p' /usr/share/cinnamon/js/ui/panel.js

echo ""
echo "=== Lines 320-410 (panel creation) ==="
sed -n '320,410p' /usr/share/cinnamon/js/ui/panel.js
