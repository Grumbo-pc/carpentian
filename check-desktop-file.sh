#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== ubiquity.desktop ==="
cat /usr/share/applications/ubiquity.desktop 2>/dev/null || echo "MISSING ubiquity.desktop"
echo "=== 25adduser copies Install icon? ==="
grep -n "desktop\|install\|ubiquity" /usr/share/initramfs-tools/scripts/casper-bottom/25adduser | head
'