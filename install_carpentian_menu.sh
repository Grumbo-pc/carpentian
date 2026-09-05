#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot
SRC=/mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/carpentian-menu

echo "=== Installing carpentian-menu applet ==="
mkdir -p "$CHROOT/usr/share/cinnamon/applets/carpentian-menu@carpentian"
cp "$SRC/metadata.json" "$CHROOT/usr/share/cinnamon/applets/carpentian-menu@carpentian/"
cp "$SRC/applet.js" "$CHROOT/usr/share/cinnamon/applets/carpentian-menu@carpentian/"
cp "$SRC/stylesheet.css" "$CHROOT/usr/share/cinnamon/applets/carpentian-menu@carpentian/"

echo "=== Removing old menu applets ==="
rm -rf "$CHROOT/usr/share/cinnamon/applets/menu@cinnamon.org" 2>/dev/null || true
rm -rf "$CHROOT/usr/share/cinnamon/applets/Cinnamenu@json" 2>/dev/null || true

echo "=== Updating gschema override ==="
cat > "$CHROOT/usr/share/glib-2.0/schemas/11_cinnamon.gschema.override" << 'GSOVERIDE'
[org.cinnamon]
enabled-applets=["panel1:left:0:carpentian-menu@carpentian", "panel1:center:0:grouped-window-list@cinnamon.org", "panel1:right:7:systray@cinnamon.org", "panel1:right:6:xapp-status@cinnamon.org", "panel1:right:5:notifications@cinnamon.org", "panel1:right:4:network@cinnamon.org", "panel1:right:3:sound@cinnamon.org", "panel1:right:2:power@cinnamon.org", "panel1:right:1:calendar@cinnamon.org", "panel1:right:0:show-desktop@cinnamon.org"]
panels-enabled=["1:0:bottom"]
panels-height=["1:40"]
next-applet-id=10
favorite-apps=["firefox_firefox.desktop", "org.gnome.Nautilus.desktop", "org.gnome.Terminal.desktop", "cinnamon-settings.desktop", "libreoffice-writer.desktop"]
GSOVERIDE

echo "=== Recompiling gschema ==="
chroot "$CHROOT" glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>&1

echo "=== Updating autostart script ==="
cat > "$CHROOT/usr/share/customscripts/carpentian-panel-setup.sh" << 'SETUPSCRIPT'
#!/bin/bash
MARKER="$HOME/.config/.carpentian-panel-setup-done"
if [ -f "$MARKER" ]; then
    exit 0
fi
touch "$MARKER"

gsettings reset org.cinnamon panels-enabled
gsettings reset org.cinnamon enabled-applets
gsettings reset org.cinnamon panels-height
gsettings reset org.cinnamon next-applet-id
gsettings reset org.cinnamon favorite-apps

dconf write /org/cinnamon/panels-enabled "['1:0:bottom']"
dconf write /org/cinnamon/panels-height "['1:40']"
dconf write /org/cinnamon/next-applet-id "10"
dconf write /org/cinnamon/favorite-apps "['firefox_firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'cinnamon-settings.desktop', 'libreoffice-writer.desktop']"
dconf write /org/cinnamon/enabled-applets "['panel1:left:0:carpentian-menu@carpentian:1', 'panel1:center:0:grouped-window-list@cinnamon.org:2', 'panel1:right:7:systray@cinnamon.org:3', 'panel1:right:6:xapp-status@cinnamon.org:4', 'panel1:right:5:notifications@cinnamon.org:5', 'panel1:right:4:network@cinnamon.org:6', 'panel1:right:3:sound@cinnamon.org:7', 'panel1:right:2:power@cinnamon.org:8', 'panel1:right:1:calendar@cinnamon.org:9', 'panel1:right:0:show-desktop@cinnamon.org:10']"

cinnamon --replace &
SETUPSCRIPT
chmod +x "$CHROOT/usr/share/customscripts/carpentian-panel-setup.sh"

echo "=== Clearing .cinnamon cache ==="
rm -rf "$CHROOT/home/carpentian/.cinnamon"
mkdir -p "$CHROOT/home/carpentian/.cinnamon/configs"
chroot "$CHROOT" chown -R 1000:1000 /home/carpentian/

echo "=== Removing Cinnamenu config remnants ==="
rm -rf "$CHROOT/home/carpentian/.cinnamon/configs/Cinnamenu@json" 2>/dev/null || true
rm -rf "$CHROOT/home/carpentian/.cinnamon/applets/Cinnamenu@json" 2>/dev/null || true

echo "=== Verifying applet files ==="
ls -la "$CHROOT/usr/share/cinnamon/applets/carpentian-menu@carpentian/"

echo "=== Removing Cinnamenu favorites remnant from dconf local ==="
rm -f "$CHROOT/etc/dconf/db/local.d/02-favorites" 2>/dev/null || true
rm -f "$CHROOT/etc/dconf/db/local.d/03-panels" 2>/dev/null || true

echo "=== Updating main dconf local file ==="
cat > "$CHROOT/etc/dconf/db/local.d/01-carpentian" << 'DCONF'
[org/cinnamon/desktop/interface]
gtk-theme='Carpentian-Win9x'
icon-theme='Carpentian-Gnome'
cursor-theme='Carpentian-cursors'
font-name='Liberation Sans 10'
document-font-name='Liberation Sans 10'
monospace-font-name='Liberation Mono 10'

[org/cinnamon/desktop/sounds]
theme-name='Vicious'
event-sounds='true'
input-feedback-sounds='true'

[org/cinnamon/theme]
name='Carpentian-Win9x'

[org/cinnamon/desktop/wm/preferences]
titlebar-font='Liberation Sans Bold 10'
button-layout='appmenu:minimize,maximize,close'

[org/cinnamon/enabled-applets]
["panel1:left:0:carpentian-menu@carpentian:1","panel1:center:0:grouped-window-list@cinnamon.org:2","panel1:right:7:systray@cinnamon.org:3","panel1:right:6:xapp-status@cinnamon.org:4","panel1:right:5:notifications@cinnamon.org:5","panel1:right:4:network@cinnamon.org:6","panel1:right:3:sound@cinnamon.org:7","panel1:right:2:power@cinnamon.org:8","panel1:right:1:calendar@cinnamon.org:9","panel1:right:0:show-desktop@cinnamon.org:10"]

[org/cinnamon/panels-enabled]
["1:0:bottom"]

[org/cinnamon/panels-height]
["1:40"]

[org/cinnamon/next-applet-id]
10

[org/cinnamon/favorite-apps]
["firefox_firefox.desktop", "org.gnome.Nautilus.desktop", "org.gnome.Terminal.desktop", "cinnamon-settings.desktop", "libreoffice-writer.desktop"]
DCONF

echo "=== Running dconf update ==="
chroot "$CHROOT" dconf update 2>&1

echo "=== ALL DONE ==="
