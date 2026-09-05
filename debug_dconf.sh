#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

echo "=== dconf profile ==="
cat "$CHROOT/etc/dconf/profile/user"

echo "=== dconf db dir ==="
ls -la "$CHROOT/etc/dconf/db/"

echo "=== dconf db.local.dir ==="
ls -la "$CHROOT/etc/dconf/db/local.d/"

echo "=== dconf db.local file ==="
ls -la "$CHROOT/etc/dconf/db/local" 2>/dev/null || echo "NO LOCAL DB FILE"

echo "=== locks dir ==="
ls -la "$CHROOT/etc/dconf/db/local.d/locks/" 2>/dev/null

echo "=== Try dconf dump ==="
dconf dump /org/cinnamon/ 2>/dev/null | head -20

echo "=== Try in chroot ==="
chroot "$CHROOT" dconf read /org/cinnamon/enabled-applets 2>/dev/null

echo "=== Verify the local db has content ==="
strings "$CHROOT/etc/dconf/db/local" 2>/dev/null | grep -i "cinnamenu\|enabled" | head -10
