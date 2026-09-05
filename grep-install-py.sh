#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== install.py: apt usage / pool refs ==="
grep -nE "pool|cdrom|apt|ko.deb|\.deb|manifest|distribution|apt-get|/cdrom" /usr/share/ubiquity/install.py | head -40
'