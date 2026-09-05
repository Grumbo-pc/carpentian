#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== /usr/lib/ubiquity tree ==="
find /usr/lib/ubiquity -maxdepth 3 -type f 2>/dev/null | head -40
echo
echo "=== file sizes ==="
du -sh /usr/lib/ubiquity 2>/dev/null
echo "=== apt-cache shows package files? (verify install state) ==="
dpkg -s ubiquity ubiquity-frontend-gtk ubiquity-casper 2>/dev/null | grep -E "^Package|^Status|^Installed-Size"
'