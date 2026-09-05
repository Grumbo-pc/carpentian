#!/bin/bash
echo "=== _fullPanelLoad ==="
grep -n "_fullPanelLoad" /usr/share/cinnamon/js/ui/panel.js | head -5

echo ""
echo "=== _fullPanelLoad body ==="
grep -n "_fullPanelLoad" /usr/share/cinnamon/js/ui/panel.js
