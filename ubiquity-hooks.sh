#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash <<'EOF'
export DEBIAN_FRONTEND=noninteractive
apt-get install -y -qq grub-efi-amd64 2>&1 | tail -3
echo "=== ubiquity shipped casper/autostart bits ==="
find /usr/lib/ubiquity -maxdepth 2 -iname '*autostart*' -o -maxdepth 2 -iname '*casper*' 2>/dev/null
echo "--- find any xdg autostart shipped by ubiquity/ubuntu-settings ---"
find /etc/xdg/autostart /usr/share/autostart -iname '*ubiquity*' 2>/dev/null
dpkg -L ubiquity-casper 2>/dev/null | grep -v doc
echo "--- ubiquity.cfg / debconf preseed for only-ubiquity? ---"
grep -rn 'only-ubiquity\|automatic-ubiquity' /usr/lib/ubiquity/ /usr/share/ubiquity/ 2>/dev/null | head
EOF