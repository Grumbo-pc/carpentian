#!/bin/bash
set -ex

echo "=== Create files via chroot (native Linux) ==="
chroot /root/carpentian-build/chroot /bin/bash << 'CHROOT_CMDS'
set -ex
MENU_DIR=/usr/share/cinnamon/applets/menu@cinnamon.org

# Delete and recreate to clear layers
rm -rf "$MENU_DIR"
mkdir -p "$MENU_DIR"

# Write applet.js from backup (will be reinstalled first)
echo "Files in menu dir:"
ls -la "$MENU_DIR/"
CHROOT_CMDS
