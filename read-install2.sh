#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== install.py 340-520 ==="
sed -n "340,520p" /usr/share/ubiquity/install.py
'