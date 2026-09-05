#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

echo "=== Setting up /etc/skel for Cinnamon ==="

# Create the XDG-compliant config path in skel
mkdir -p "$CHROOT/etc/skel/.config/cinnamon/spices/carpentian-menu@carpentian"
mkdir -p "$CHROOT/etc/skel/.cinnamon"
mkdir -p "$CHROOT/etc/skel/.local/share/cinnamon/applets"

# Copy the applet into skel's local applets (user-level install)
cp -r "$CHROOT/usr/share/cinnamon/applets/carpentian-menu@carpentian" \
      "$CHROOT/etc/skel/.local/share/cinnamon/applets/"

# Create Cinnamenu config in .config/cinnamon/spices/ (XDG path)
cat > "$CHROOT/etc/skel/.config/cinnamon/spices/carpentian-menu@carpentian/0.json" << 'APPCONFIG'
{
    "menu-icon": {
        "type": "string",
        "value": "carpentian-menu"
    },
    "menu-label": {
        "type": "string",
        "value": "Carpentian"
    }
}
APPCONFIG

echo "=== skel structure ==="
find "$CHROOT/etc/skel" -type f | head -30

echo "=== Recompiling gschema ==="
chroot "$CHROOT" glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>&1

echo "=== Running dconf update ==="
chroot "$CHROOT" dconf update 2>&1

echo "=== Verifying dconf keys ==="
chroot "$CHROOT" dconf dump /org/cinnamon/ 2>&1 | head -30

echo "=== DONE ==="
