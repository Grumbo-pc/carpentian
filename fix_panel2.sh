#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

# === 1. Fix Cinnamenu metadata to include Cinnamon 6.0 ===
cat > "$CHROOT/usr/share/cinnamon/applets/Cinnamenu@json/metadata.json" << 'METAEOF'
{
    "uuid": "Cinnamenu@json",
    "name": "Cinnamenu",
    "description": "A flexible menu with grid or list layout options, file browser and emoji search.",
    "max-instances": 2,
    "version": "5.8.0",
    "multiversion": false,
    "cinnamon-version": ["3.2","3.4","3.6","3.8","4.0","4.2","4.4","4.6","4.8","5.0","5.2","5.4","5.6","5.8","6.0","6.2","6.4"],
    "author": "fredcw"
}
METAEOF

# === 2. Set panels-enabled in dconf ===
# This tells Cinnamon which panels exist
cat > "$CHROOT/etc/dconf/db/local.d/03-panels" << 'PANELSEOF'
[org/cinnamon]
panels-enabled=["1:288:center:0"]
PANELSEOF

# === 3. Rebuild dconf ===
chroot "$CHROOT" dconf update

# === 4. Verify ===
echo "=== panels-enabled ==="
chroot "$CHROOT" dconf read /org/cinnamon/panels-enabled
echo "=== enabled-applets ==="
chroot "$CHROOT" dconf read /org/cinnamon/enabled-applets
echo "=== metadata ==="
cat "$CHROOT/usr/share/cinnamon/applets/Cinnamenu@json/metadata.json"

echo "=== DONE ==="
