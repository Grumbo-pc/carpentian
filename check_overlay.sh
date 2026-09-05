#!/bin/bash
set -ex
CHROOT=/root/carpentian-build/chroot

echo "=== Current state of applets dir ==="
ls "$CHROOT/usr/share/cinnamon/applets/" | head -40

echo "=== Check if menu@cinnamon.org exists ==="
ls -la "$CHROOT/usr/share/cinnamon/applets/menu@cinnamon.org" 2>&1 || echo "menu@cinnamon.org NOT FOUND"

echo "=== Check if carpentian-menu@carpentian exists ==="
ls -la "$CHROOT/usr/share/cinnamon/applets/carpentian-menu@carpentian" 2>&1 || echo "carpentian-menu@carpentian NOT FOUND"

echo "=== Check overlayfs mount ==="
mount | grep overlay 2>/dev/null || echo "No overlay mounted"

echo "=== Check if chroot has upper dir ==="
ls -la /root/carpentian-build/ 2>/dev/null
