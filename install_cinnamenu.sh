#!/bin/bash
set -ex

DEST=/root/carpentian-build/chroot/usr/share/cinnamon/applets/Cinnamenu@json
SRC=/tmp/spices2/cinnamon-spices-applets-master/Cinnamenu@json/files/Cinnamenu@json/5.8
META=/tmp/spices2/cinnamon-spices-applets-master/Cinnamenu@json/files/Cinnamenu@json/metadata.json

mkdir -p "$DEST"
cp "$SRC"/* "$DEST/"
cp "$META" "$DEST/"
ls "$DEST/"

# Check settings-schema for full-screen option
echo "=== Checking settings for fullscreen ==="
grep -i "full\|screen\|layout\|mode" "$DEST/settings-schema.json" 2>/dev/null | head -20

echo "=== DONE ==="
