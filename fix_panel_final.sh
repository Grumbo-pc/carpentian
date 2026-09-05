#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

# === 1. Create gschema override for panel layout ===
cat > "$CHROOT/usr/share/glib-2.0/schemas/11_cinnamon.gschema.override" << 'GSOVERIDE'
[org.cinnamon]
enabled-applets=["panel1:left:0:Cinnamenu@json", "panel1:center:0:grouped-window-list@cinnamon.org", "panel1:right:7:systray@cinnamon.org", "panel1:right:6:xapp-status@cinnamon.org", "panel1:right:5:notifications@cinnamon.org", "panel1:right:4:network@cinnamon.org", "panel1:right:3:sound@cinnamon.org", "panel1:right:2:power@cinnamon.org", "panel1:right:1:calendar@cinnamon.org", "panel1:right:0:show-desktop@cinnamon.org"]
panels-enabled=["1:0:bottom"]
panels-height=["1:40"]
next-applet-id=10
favorite-apps=["firefox_firefox.desktop", "org.gnome.Nautilus.desktop", "org.gnome.Terminal.desktop", "cinnamon-settings.desktop", "libreoffice-writer.desktop"]
app-menu-icon-name="carpentian-menu"
GSOVERIDE

# === 2. Compile gschema ===
chroot "$CHROOT" glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>&1

# === 3. Create autostart .desktop file ===
mkdir -p "$CHROOT/etc/xdg/autostart"
cat > "$CHROOT/etc/xdg/autostart/carpentian-panel-setup.desktop" << 'AUTOSTART'
[Desktop Entry]
Type=Application
Name=Carpentian Panel Setup
Exec=/usr/share/customscripts/carpentian-panel-setup.sh
X-GNOME-Autostart-enabled=true
AUTOSTART

# === 4. Create the autostart script ===
mkdir -p "$CHROOT/usr/share/customscripts"
cat > "$CHROOT/usr/share/customscripts/carpentian-panel-setup.sh" << 'SETUPSCRIPT'
#!/bin/bash
# Only run once for first-time setup
MARKER="$HOME/.config/.carpentian-panel-setup-done"
if [ -f "$MARKER" ]; then
    exit 0
fi
touch "$MARKER"

# Reset to force Cinnamon to re-read gschema defaults
gsettings reset org.cinnamon panels-enabled
gsettings reset org.cinnamon enabled-applets
gsettings reset org.cinnamon panels-height
gsettings reset org.cinnamon panels-resizable
gsettings reset org.cinnamon next-applet-id
gsettings reset org.cinnamon favorite-apps
gsettings reset org.cinnamon app-menu-icon-name

# Set the values explicitly
dconf write /org/cinnamon/panels-enabled "['1:0:bottom']"
dconf write /org/cinnamon/panels-height "['1:40']"
dconf write /org/cinnamon/panels-resizable "['1:true']"
dconf write /org/cinnamon/next-applet-id "10"
dconf write /org/cinnamon/favorite-apps "['firefox_firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'cinnamon-settings.desktop', 'libreoffice-writer.desktop']"
dconf write /org/cinnamon/app-menu-icon-name "'carpentian-menu'"
dconf write /org/cinnamon/enabled-applets "['panel1:left:0:Cinnamenu@json:1', 'panel1:center:0:grouped-window-list@cinnamon.org:2', 'panel1:right:7:systray@cinnamon.org:3', 'panel1:right:6:xapp-status@cinnamon.org:4', 'panel1:right:5:notifications@cinnamon.org:5', 'panel1:right:4:network@cinnamon.org:6', 'panel1:right:3:sound@cinnamon.org:7', 'panel1:right:2:power@cinnamon.org:8', 'panel1:right:1:calendar@cinnamon.org:9', 'panel1:right:0:show-desktop@cinnamon.org:10']"

# Restart Cinnamon to apply
cinnamon --replace &
SETUPSCRIPT

chmod +x "$CHROOT/usr/share/customscripts/carpentian-panel-setup.sh"

# === 5. Also clear any stale .cinnamon ===
rm -rf "$CHROOT/home/carpentian/.cinnamon"
mkdir -p "$CHROOT/home/carpentian/.cinnamon/configs"
mkdir -p "$CHROOT/home/carpentian/.cinnamon/configs/Cinnamenu@json"
cp /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/cinnamenu-config.json "$CHROOT/home/carpentian/.cinnamon/configs/Cinnamenu@json/0.json"
cp /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/cinnamenu-stylesheet.css "$CHROOT/home/carpentian/.cinnamon/configs/Cinnamenu@json/stylesheet.css"
chroot "$CHROOT" chown -R 1000:1000 /home/carpentian/

echo "=== gschema override ==="
cat "$CHROOT/usr/share/glib-2.0/schemas/11_cinnamon.gschema.override"

echo "=== autostart desktop ==="
cat "$CHROOT/etc/xdg/autostart/carpentian-panel-setup.desktop"

echo "=== DONE ==="
