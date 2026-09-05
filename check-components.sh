#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== components present ==="
ls /usr/lib/ubiquity/ubiquity/components/ | head -60
echo "=== split packages check ==="
for p in ubiquity-frontend-kde ubiquity-artwork ubiquity-slideshow; do
  dpkg -l $p 2>/dev/null | grep ^ii && echo "  ^ present"
done
echo "=== ubiquity depends ==="
apt-cache depends ubiquity | head -40
'