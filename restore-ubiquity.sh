#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash <<'EOF'
export DEBIAN_FRONTEND=noninteractive
apt-get purge -y -qq grub-efi-amd64 2>&1 | tail -2
apt-get install -y -qq grub-pc ubiquity ubiquity-frontend-gtk 2>&1 | tail -4
echo "=== verify ubiquity present ==="
dpkg -l ubiquity ubiquity-frontend-gtk grub-pc 2>/dev/null | grep ^ii
echo "=== ubiquity launcher files ==="
ls -la /usr/bin/ubiquity /usr/lib/ubiquity/bin/ubiquity 2>/dev/null
echo "=== frontend modules ==="
find /usr/lib/ubiquity/ubiquity/frontend -maxdepth 1 -type d 2>/dev/null
ls /usr/lib/ubiquity/ubiquity/ 2>/dev/null | head
EOF