#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
export PYTHONPATH=/usr/lib/ubiquity
echo "=== how install.py drives apt install ==="
sed -n "1,60p" /usr/lib/ubiquity/ubiquity/components/install.py
'