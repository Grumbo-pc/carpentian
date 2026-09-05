#!/bin/bash
grep -rn "config" /usr/share/cinnamon/js/ui/appletManager.js 2>/dev/null | head -20
echo "==="
grep -rn "getConfig" /usr/share/cinnamon/js/ui/appletManager.js 2>/dev/null | head -10
echo "==="
grep -rn "Spices\|spices\|configs" /usr/share/cinnamon/js/ui/appletManager.js 2>/dev/null | head -10
