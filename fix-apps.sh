#!/bin/bash
set -e
CHROOT=/root/carpentian-build/chroot

echo '=== Fixing Firefox (snap transitional -> real .deb) ==='
chroot $CHROOT /bin/bash -c '
apt-get remove -y firefox 2>/dev/null || true
apt-get install -y -qq wget
wget -q -O /tmp/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
cd /opt
tar xjf /tmp/firefox.tar.bz2
ln -sf /opt/firefox/firefox /usr/bin/firefox
mkdir -p /usr/share/applications
cat > /usr/share/applications/firefox.desktop << EOF
[Desktop Entry]
Name=Firefox Web Browser
Exec=/opt/firefox/firefox %u
Icon=firefox
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;image/svg+xml;
StartupNotify=true
EOF
cp /opt/firefox/browser/chrome/icons/default/default128.png /usr/share/icons/hicolor/128x128/apps/firefox.png 2>/dev/null || true
cp /opt/firefox/browser/chrome/icons/default/default48.png /usr/share/icons/hicolor/48x48/apps/firefox.png 2>/dev/null || true
cp /opt/firefox/browser/chrome/icons/default/default16.png /usr/share/icons/hicolor/16x16/apps/firefox.png 2>/dev/null || true
rm -f /tmp/firefox.tar.bz2
echo "Real Firefox installed from Mozilla"
'

echo '=== Fixing Spotify ==='
chroot $CHROOT /bin/bash -c '
rm -f /etc/apt/sources.list.d/spotify.list
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor -o /usr/share/keyrings/spotify.gpg
echo "deb [signed-by=/usr/share/keyrings/spotify.gpg] http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list
apt-get update -qq
apt-get install -y -qq spotify-client
echo "Spotify installed"
'

echo '=== ALL FIXED ==='
