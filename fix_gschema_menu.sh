#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

echo "=== Step 4: Update gschema override to use menu@cinnamon.org ==="
cat > "$CHROOT/usr/share/glib-2.0/schemas/11_cinnamon.gschema.override" << 'GSOVERIDE'
[org.cinnamon]
enabled-applets=['panel1:left:0:menu@cinnamon.org:1', 'panel1:center:0:grouped-window-list@cinnamon.org:2', 'panel1:right:7:systray@cinnamon.org:3', 'panel1:right:6:xapp-status@cinnamon.org:4', 'panel1:right:5:notifications@cinnamon.org:5', 'panel1:right:4:network@cinnamon.org:6', 'panel1:right:3:sound@cinnamon.org:7', 'panel1:right:2:power@cinnamon.org:8', 'panel1:right:1:calendar@cinnamon.org:9', 'panel1:right:0:show-desktop@cinnamon.org:10']
panels-enabled=['1:0:bottom']
panels-height=['1:40']
next-applet-id=10
favorite-apps=['firefox_firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'cinnamon-settings.desktop', 'libreoffice-writer.desktop']
GSOVERIDE

echo "=== Step 5: Recompile gschema ==="
chroot "$CHROOT" glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>&1

echo "=== Step 6: Update dconf ==="
chroot "$CHROOT" dconf update 2>&1

echo "=== Step 7: Update autostart script ==="
cat > "$CHROOT/usr/share/customscripts/carpentian-panel-setup.sh" << 'SETUP'
#!/bin/bash
# Carpentian panel layout - runs on every login
dconf write /org/cinnamon/panels-enabled "['1:0:bottom']"
dconf write /org/cinnamon/panels-height "['1:40']"
dconf write /org/cinnamon/next-applet-id 10
dconf write /org/cinnamon/enabled-applets "['panel1:left:0:menu@cinnamon.org:1', 'panel1:center:0:grouped-window-list@cinnamon.org:2', 'panel1:right:7:systray@cinnamon.org:3', 'panel1:right:6:xapp-status@cinnamon.org:4', 'panel1:right:5:notifications@cinnamon.org:5', 'panel1:right:4:network@cinnamon.org:6', 'panel1:right:3:sound@cinnamon.org:7', 'panel1:right:2:power@cinnamon.org:8', 'panel1:right:1:calendar@cinnamon.org:9', 'panel1:right:0:show-desktop@cinnamon.org:10']"
SETUP
chmod +x "$CHROOT/usr/share/customscripts/carpentian-panel-setup.sh"

echo "=== Step 8: Clear user .cinnamon cache ==="
rm -rf "$CHROOT/home/carpentian/.cinnamon"
mkdir -p "$CHROOT/home/carpentian/.cinnamon"
chroot "$CHROOT" chown -R 1000:1000 /home/carpentian/

echo "=== Step 9: Verify gsettings ==="
chroot "$CHROOT" /bin/bash -c 'gsettings get org.cinnamon enabled-applets' 2>&1

echo "=== DONE ==="
