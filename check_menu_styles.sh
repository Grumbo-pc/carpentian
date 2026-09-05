#!/bin/bash
set -ex
CHROOT=/root/carpentian-build/chroot
MENU="$CHROOT/usr/share/cinnamon/applets/menu@cinnamon.org"

echo "=== Check for stylesheet ==="
ls "$MENU/"*.css 2>&1 || echo "No CSS files"

echo "=== Check applet.js for styling ==="
grep -n "style_class\|stylesheet\|css\|style" "$MENU/applet.js" | head -20

echo "=== Check metadata.json ==="
cat "$MENU/metadata.json"
