#!/bin/bash
cd /root/carpentian-build/chroot/usr/share/sounds/Vicious/stereo
echo "--- bogus file contents ---"
for f in bell.oga button-pressed.ogg button-released.ogg; do
    echo "$f: $(cat "$f")"
done
echo "--- valid ogg/vorbis files (with real size) ---"
for f in *.oga; do
    sz=$(stat -c %s "$f")
    magic=$(head -c 4 "$f")
    echo "$f size=$sz magic=$magic"
done | grep -v 'size=2' | grep -v 'magic=OggS' | head -30