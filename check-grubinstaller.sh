#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== grubinstaller component ==="
cat /usr/lib/ubiquity/ubiquity/components/grubinstaller.py
echo "=== apt-install-direct usage across ubiquity ==="
grep -rn "apt-install-direct\|apt-get install\|apt-get -y install" /usr/lib/ubiquity/ /usr/share/ubiquity/ 2>/dev/null | grep -v "\.pyc" | head
'