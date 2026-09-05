#!/bin/bash
set -ex
CHROOT=/root/carpentian-build/chroot

echo "=== Reinstall cinnamon-common ==="
chroot "$CHROOT" apt-get install --reinstall cinnamon-common -y 2>&1 | tail -10

echo "=== Verify ==="
ls "$CHROOT/usr/share/cinnamon/applets/menu@cinnamon.org/" 2>&1
