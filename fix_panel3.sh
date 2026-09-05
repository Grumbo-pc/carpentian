#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

# === 1. Fix panels-enabled format: id:monitor:position ===
# panel 1 on monitor 0 at bottom
cat > "$CHROOT/etc/dconf/db/local.d/03-panels" << 'PANELSEOF'
[org/cinnamon]
panels-enabled=["1:0:bottom"]
PANELSEOF

# === 2. Fix enabled-applets format: panelN:side:index:applet-id ===
# Also remove the old menu@cinnamon.org completely so Cinnamon can't fall back
rm -rf "$CHROOT/usr/share/cinnamon/applets/menu@cinnamon.org" 2>/dev/null || true

# === 3. Rebuild dconf ===
chroot "$CHROOT" dconf update

# === 4. Verify everything ===
echo "=== panels-enabled ==="
chroot "$CHROOT" dconf read /org/cinnamon/panels-enabled
echo "=== enabled-applets ==="
chroot "$CHROOT" dconf read /org/cinnamon/enabled-applets
echo "=== menu@cinnamon.org removed? ==="
ls "$CHROOT/usr/share/cinnamon/applets/menu@cinnamon.org" 2>&1 || echo "REMOVED (good)"
echo "=== Cinnamenu exists? ==="
ls "$CHROOT/usr/share/cinnamon/applets/Cinnamenu@json/metadata.json"

echo "=== DONE ==="
