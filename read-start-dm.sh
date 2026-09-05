#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
cat /usr/share/ubiquity/start-ubiquity-dm
echo "=== ubiquity.cfg? ==="
ls /etc/ubiquity* /usr/share/ubiquity/*.cfg 2>/dev/null
echo "=== debconf uses = ==="
grep -rn "only-ubiquity" /usr/lib/ubiquity 2>/dev/null | head
'