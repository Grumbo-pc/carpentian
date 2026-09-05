#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

echo "=== panels-enabled key ==="
chroot "$CHROOT" dconf read /org/cinnamon/enabled-applets
chroot "$CHROOT" dconf read /org/cinnamon/panels-enabled

echo "=== Check if Cinnamenu applet has errors ==="
# Try to load it in a JS check
chroot "$CHROOT" /bin/bash -c 'node -e "try { require(\"/usr/share/cinnamon/applets/Cinnamenu@json/applet.js\"); } catch(e) { print(e.message); }" 2>&1' || true

echo "=== Check applet.js header for dependencies ==="
head -30 "$CHROOT/usr/share/cinnamon/applets/Cinnamenu@json/applet.js" 2>/dev/null

echo "=== Check metadata.json ==="
cat "$CHROOT/usr/share/cinnamon/applets/Cinnamenu@json/metadata.json" 2>/dev/null
