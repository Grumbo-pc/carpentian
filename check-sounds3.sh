#!/bin/bash
cd /root/carpentian-build/chroot/usr/share/sounds/Vicious/stereo
ls -la | head -40
echo "=== file types of suspicious files ==="
file bell.oga button-pressed.ogg button-released.ogg complete-media-error.oga bell-window-system.oga complete.oga desktop-login.oga 2>/dev/null
echo "=== symlink targets ==="
for f in *; do
    if [ -L "$f" ]; then
        echo "$f -> $(readlink "$f")"
    fi
done
echo "=== real size of button-pressed.ogg via ls ==="
ls -l button-pressed.ogg button-released.ogg