#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== update-apt-cache script ==="
cat /usr/share/ubiquity/update-apt-cache 2>/dev/null | head -60
echo "=== install.py apt cache build (update_apt_cache callers) ==="
grep -n "update_apt_cache\|update-apt-cache\|apt_cache" /usr/share/ubiquity/install.py | head
'