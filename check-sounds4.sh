#!/bin/bash
cd /root/carpentian-build/chroot/usr/share/sounds/Vicious/stereo
echo "=== BROKEN (non-Ogg) files ==="
for f in *.oga *.ogg *.wav; do
    [ -e "$f" ] || continue
    if [ -L "$f" ]; then
        tgt=$(readlink -f "$f")
        if [ -e "$tgt" ]; then
            if ! head -c 4 "$f" | grep -q OggS; then
                echo "SYMLINK-BROKEN: $f -> $tgt ($(head -c 30 "$f" | tr -d '\0'))"
            fi
        else
            echo "DENYLED: $f"
        fi
    else
        if ! head -c 4 "$f" | grep -q OggS; then
            echo "BROKEN: $f size=$(stat -c %s "$f") content=[$(head -c 40 "$f" | tr -d '\0')]"
        fi
    fi
done
echo "=== done ==="