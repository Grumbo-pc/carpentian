#!/bin/bash
set -ex

MENU_DIR=/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org

echo "=== Save originals ==="
cp "$MENU_DIR/applet.js" /tmp/original_applet.js
cp "$MENU_DIR/appUtils.js" /tmp/original_appUtils.js
cp "$MENU_DIR/metadata.json" /tmp/original_metadata.json
cp "$MENU_DIR/settings-schema.json" /tmp/original_settings-schema.json

echo "=== Delete and recreate ==="
rm -rf "$MENU_DIR"
mkdir -p "$MENU_DIR"

echo "=== Copy back originals ==="
cp /tmp/original_applet.js "$MENU_DIR/applet.js"
cp /tmp/original_appUtils.js "$MENU_DIR/appUtils.js"
cp /tmp/original_metadata.json "$MENU_DIR/metadata.json"
cp /tmp/original_settings-schema.json "$MENU_DIR/settings-schema.json"

echo "=== List the clean directory ==="
ls -la "$MENU_DIR/"
