#!/bin/bash
set -e

# Fix ldconfig for spotify libs
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "/usr/share/spotify" > /etc/ld.so.conf.d/spotify.conf
ldconfig
ldconfig -p | grep libcef
'

# Clean Spotify desktop to just use the standard binary
chroot /root/carpentian-build/chroot /bin/bash -c '
cat > /usr/share/applications/spotify.desktop << "DESKTOP"
[Desktop Entry]
Type=Application
Name=Spotify
GenericName=Music Player
Icon=spotify-client
TryExec=spotify
Exec=spotify %U
Terminal=false
MimeType=x-scheme-handler/spotify;
Categories=Audio;Music;Player;AudioVideo;
DESKTOP
'

# Clean VS Code desktop - remove our broken edit
chroot /root/carpentian-build/chroot /bin/bash -c '
cat > /usr/share/applications/code.desktop << "DESKTOP"
[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=/usr/share/code/code --no-sandbox %F
Icon=vscode
Type=Application
StartupNotify=true
StartupWMClass=Code
Categories=TextEditor;Development;IDE;
DESKTOP
'

# Verify both .desktop files
echo "=== Spotify desktop ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'cat /usr/share/applications/spotify.desktop'
echo ""
echo "=== VS Code desktop ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'cat /usr/share/applications/code.desktop'

# Check if VS Code has all deps
echo "=== VS Code missing libs ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'ldd /usr/share/code/code 2>&1' | grep "not found"

echo "=== DONE ==="
