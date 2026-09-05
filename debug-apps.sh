#!/bin/bash
set -e

# Fix Spotify wrapper to set LD_LIBRARY_PATH
chroot /root/carpentian-build/chroot /bin/bash -c 'cat > /usr/bin/spotify << "SPOTIFY"
#!/bin/sh
export LD_LIBRARY_PATH=/usr/share/spotify:$LD_LIBRARY_PATH
exec /usr/share/spotify/spotify "$@"
SPOTIFY
chmod +x /usr/bin/spotify'

# Fix Spotify desktop
chroot /root/carpentian-build/chroot /bin/bash -c 'cat > /usr/share/applications/spotify.desktop << "DESKTOP"
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
DESKTOP'

# Fix VS Code desktop to always use --no-sandbox for live session
chroot /root/carpentian-build/chroot /bin/bash -c 'sed -i "s|Exec=/usr/share/code/code --no-sandbox %F|Exec=/usr/share/code/code --no-sandbox --user-data-dir /home/carpentian/.config/Code %F|" /usr/share/applications/code.desktop'

# Add spotify lib path to ldconfig
chroot /root/carpentian-build/chroot /bin/bash -c 'echo "/usr/share/spotify" > /etc/ld.so.conf.d/spotify.conf && ldconfig'

# Verify
echo "=== Spotify ldd ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'LD_LIBRARY_PATH=/usr/share/spotify ldd /usr/share/spotify/spotify 2>&1 | grep "not found"'
echo "=== VS Code ldd ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'ldd /usr/share/code/code 2>&1 | grep "not found"'
echo "=== Done ==="
