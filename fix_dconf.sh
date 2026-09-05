#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot
WINPATH=/mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian

# === 1. Fix the dconf file - rewrite cleanly ===
cat > "$CHROOT/etc/dconf/db/local.d/01-carpentian" << 'DCONFEOF'
[org/cinnamon]
enabled-applets=["panel1:left:0:Cinnamenu@json", "panel1:center:0:grouped-window-list@cinnamon.org", "panel1:right:7:systray@cinnamon.org", "panel1:right:6:xapp-status@cinnamon.org", "panel1:right:5:notifications@cinnamon.org", "panel1:right:4:network@cinnamon.org", "panel1:right:3:sound@cinnamon.org", "panel1:right:2:power@cinnamon.org", "panel1:right:1:calendar@cinnamon.org", "panel1:right:0:show-desktop@cinnamon.org"]
[org/cinnamon/desktop/interface]
icon-theme='Carpentian-Gnome'
cursor-theme='Carpentian-cursors'
cursor-size=24
font-name='Sans 11'
document-font-name='Sans 11'
monospace-font-name='Monospace 12'
gtk-theme='Carpentian-Win9x'

[org/cinnamon/desktop/background]
picture-uri='file:///usr/share/backgrounds/carpentian/Default1.jpg'
picture-options='zoom'

[org/cinnamon/desktop/screensaver]
picture-uri='file:///usr/share/backgrounds/carpentian/LockScreen.jpg'

[org/cinnamon/desktop/sound]
theme-name='freedesktop'
event-sounds=true
input-feedback-sounds=true
volume-sound-enabled=true
volume-sound-file='/usr/share/mint-artwork/sounds/plug.wav'

[org/cinnamon/desktop/wm/preferences]
theme='Carpentian-Win9x'
titlebar-font='Sans Bold 11'
button-layout='appmenu:minimize,maximize,close'

[org/cinnamon/theme]
name='Carpentian-Win9x'

[org/cinnamon/sounds]
login-enabled=true
login-file='/usr/share/mint-artwork/sounds/login.ogg'
logout-enabled=true
logout-file='/usr/share/mint-artwork/sounds/logout.ogg'
plug-enabled=true
plug-file='/usr/share/mint-artwork/sounds/plug.ogg'
unplug-enabled=true
unplug-file='/usr/share/mint-artwork/sounds/unplug.ogg'
switch-enabled=true
switch-file='/usr/share/mint-artwork/sounds/switch.ogg'
close-enabled=true
close-file='/usr/share/mint-artwork/sounds/close.ogg'
map-enabled=true
map-file='/usr/share/mint-artwork/sounds/map.ogg'
minimize-enabled=true
minimize-file='/usr/share/mint-artwork/sounds/minimize.ogg'
maximize-enabled=true
maximize-file='/usr/share/mint-artwork/sounds/maximize.ogg'
unmaximize-enabled=true
unmaximize-file='/usr/share/mint-artwork/sounds/unmaximize.ogg'
tile-enabled=true
tile-file='/usr/share/mint-artwork/sounds/tile.ogg'
notification-enabled=true
notification-file='/usr/share/mint-artwork/sounds/notification.ogg'
DCONFEOF

# === 2. Add favorites config ===
cat > "$CHROOT/etc/dconf/db/local.d/02-favorites" << 'FAVSEOF'
[org/cinnamon]
favorite-apps=['firefox_firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'cinnamon-settings.desktop', 'libreoffice-writer.desktop']
FAVSEOF

# === 3. Update dconf ===
chroot "$CHROOT" dconf update

# === 4. Set ownership ===
chroot "$CHROOT" chown -R 1000:1000 /home/carpentian/.cinnamon/

# === 5. Copy Cinnamenu stylesheet into applet dir for default fallback ===
cp "$WINPATH/cinnamenu-stylesheet.css" "$CHROOT/usr/share/cinnamon/applets/Cinnamenu@json/stylesheet.css"

# === 6. Remove stale menu@cinnamon.org config (prevent conflict) ===
rm -rf "$CHROOT/home/carpentian/.cinnamon/configs/menu@cinnamon.org" 2>/dev/null || true

echo "=== Fixed dconf and setup complete ==="
cat "$CHROOT/etc/dconf/db/local.d/01-carpentian" | head -5
