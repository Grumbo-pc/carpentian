#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash <<'EOF'
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq ubiquity ubiquity-frontend-gtk ubiquity-casper ubiquity-ubuntu-artwork ubuntu-settings 2>&1 | tail -5
echo "=== installed ==="
dpkg -l | grep -i ubiquity | awk '{print $2}'
EOF