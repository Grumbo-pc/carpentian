#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

echo "=== Check if menu@cinnamon.org exists ==="
ls "$CHROOT/usr/share/cinnamon/applets/menu@cinnamon.org" 2>&1 || echo "MISSING - need to reinstall"

echo "=== Find the package that owns menu@cinnamon.org ==="
chroot "$CHROOT" dpkg -S menu@cinnamon.org 2>&1 || echo "Not found in any package"

echo "=== Reinstall cinnamon to restore menu@cinnamon.org ==="
chroot "$CHROOT" apt-get install --reinstall cinnamon -y 2>&1 | tail -10

echo "=== Verify it's back ==="
ls "$CHROOT/usr/share/cinnamon/applets/menu@cinnamon.org/" 2>&1
