#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

# === Set next-applet-id so the upgrade works ===
cat >> "$CHROOT/etc/dconf/db/local.d/01-carpentian" << 'EOF'

[org/cinnamon]
next-applet-id=10
EOF

chroot "$CHROOT" dconf update

# === Also verify what the live boot will actually read ===
echo "=== Full dconf dump ==="
chroot "$CHROOT" dconf dump /org/cinnamon/
