#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot
WINPATH=/mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian

# === 1. Install Cinnamenu config ===
CONFDIR="$CHROOT/home/carpentian/.cinnamon/configs/Cinnamenu@json"
mkdir -p "$CONFDIR"
cp "$WINPATH/cinnamenu-config.json" "$CONFDIR/0.json"
cp "$WINPATH/cinnamenu-stylesheet.css" "$CONFDIR/stylesheet.css"

# === 2. Configure panel layout via dconf ===
# The panel layout needs to replace menu@cinnamon.org with Cinnamenu@json
# and add panel-launchers for dock icons

DCONF="$CHROOT/etc/dconf/db/local.d/01-carpentian"

# Check if the panel section already exists, if so we need to be careful
cat >> "$DCONF" << 'DCONFEOF'

[org/cinnamon]
enabled-applets=["panel1:left:0:Cinnamenu@json", "panel1:center:0:grouped-window-list@cinnamon.org", "panel1:right:7:systray@cinnamon.org", "panel1:right:6:xapp-status@cinnamon.org", "panel1:right:5:notifications@cinnamon.org", "panel1:right:4:network@cinnamon.org", "panel1:right:3:sound@cinnamon.org", "panel1:right:2:power@cinnamon.org", "panel1:right:1:calendar@cinnamon.org", "panel1:right:0:show-desktop@cinnamon.org"]

[org/cinnamon/desktop/background]
picture-uri='file:///usr/share/backgrounds/carpentian/Default1.jpg'
picture-options='zoom'
DCONFEOF

# === 3. Set favorite apps for the dock ===
# These will show as pinned icons in the grouped-window-list
cat > "$CHROOT/etc/dconf/db/local.d/02-favorites" << 'FAVSEOF'

[org/cinnamon]
favorite-apps=['firefox_firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'cinnamon-settings.desktop', 'libreoffice-writer.desktop']
FAVSEOF

# === 4. Force dconf update ===
chroot "$CHROOT" dconf update 2>/dev/null || true

# === 5. Set ownership ===
chroot "$CHROOT" chown -R 1000:1000 /home/carpentian/.cinnamon/configs/ 2>/dev/null || true

echo "=== Cinnamenu setup complete ==="
ls -la "$CONFDIR/"
