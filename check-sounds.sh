#!/bin/bash
cd /root/carpentian-build/chroot/usr/share/sounds/Vicious/stereo
for f in bell.oga bell-window-system.oga button-pressed.ogg button-released.ogg complete.oga desktop-login.oga desktop-logout.oga device-added.oga device-removed.oga dialog-information.oga audio-volume-change.oga; do
    if [ -s "$f" ]; then
        echo "OK  $f $(stat -c %s "$f") bytes"
    else
        echo "MISSING $f"
    fi
done
echo "--- validate ogg magic ---"
for f in bell.oga complete.oga desktop-login.oga audio-volume-change.oga; do
    head -c 4 "$f" | xxd | head -1
done