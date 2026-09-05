#!/bin/bash
set -e

chroot /root/carpentian-build/chroot /bin/bash -c '
cd /opt
tar xJf firefox.tar
rm -f firefox.tar
ln -sf /opt/firefox/firefox /usr/bin/firefox
ls -la /opt/firefox/firefox
mkdir -p /usr/share/icons/hicolor/128x128/apps
mkdir -p /usr/share/icons/hicolor/48x48/apps
mkdir -p /usr/share/icons/hicolor/16x16/apps
cp /opt/firefox/browser/chrome/icons/default/default128.png /usr/share/icons/hicolor/128x128/apps/firefox.png 2>/dev/null || true
cp /opt/firefox/browser/chrome/icons/default/default48.png /usr/share/icons/hicolor/48x48/apps/firefox.png 2>/dev/null || true
cp /opt/firefox/browser/chrome/icons/default/default16.png /usr/share/icons/hicolor/16x16/apps/firefox.png 2>/dev/null || true
mkdir -p /usr/share/applications
cat > /usr/share/applications/firefox.desktop << DESKTOP
[Desktop Entry]
Name=Firefox Web Browser
Exec=/opt/firefox/firefox %u
Icon=firefox
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;image/svg+xml;
StartupNotify=true
DESKTOP
echo "Firefox installed successfully"
'
