#!/bin/bash
cd /root/carpentian-build/chroot/usr/share/sounds/Vicious/stereo
for f in bell.oga bell-window-system.oga button-pressed.ogg button-released.ogg complete.oga desktop-login.oga desktop-logout.oga device-added.oga device-removed.oga dialog-information.oga audio-volume-change.oga dialog-warning.oga; do
    if [ -e "$f" ]; then
        magic=$(head -c 4 "$f")
        if [ "$magic" = "OggS" ]; then
            echo "VALID $f ($(stat -c %s "$f") bytes -> $(readlink -f "$f"))"
        else
            echo "NOT-OGG $f magic=$magic"
        fi
    else
        echo "MISSING $f"
    fi
done