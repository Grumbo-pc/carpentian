#!/bin/bash

echo "=== Spotify binary check ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'ls -la /usr/bin/spotify /usr/share/spotify/spotify 2>&1'
echo "=== Spotify runs as root? ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'file /usr/share/spotify/spotify 2>&1'
echo "=== Spotify libs ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'ls /usr/share/spotify/*.so 2>/dev/null | head -10'
echo "=== Spotify package files ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'dpkg -L spotify-client 2>/dev/null | head -30'
echo "=== Spotify deps ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'apt-cache depends spotify-client 2>/dev/null | grep "Depends:" | head -10'

echo ""
echo "=== VS Code binary ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'ls -la /usr/share/code/code /usr/bin/code 2>&1'
echo "=== VS Code runs as root? ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'file /usr/share/code/code 2>&1'
echo "=== VS Code package files ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'dpkg -L code 2>/dev/null | grep -E "bin|electron|\.desktop" | head -20'
echo "=== VS Code deps ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'apt-cache depends code 2>/dev/null | grep "Depends:" | head -10'
echo "=== VS Code all missing ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'ldd /usr/share/code/code 2>&1' | grep "not found"
chroot /root/carpentian-build/chroot /bin/bash -c 'find /usr/share/code -name "*.so" -exec ldd {} \; 2>/dev/null' | grep "not found" | sort -u | head -20

echo ""
echo "=== Check dbus ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'dpkg -l dbus-x11 2>/dev/null | tail -1'
echo "=== Check XDG ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'dpkg -l xdg-utils 2>/dev/null | tail -1'
