#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== /usr/bin/ubiquity ==="
cat /usr/bin/ubiquity
echo "=== frontend dirs ==="
ls /usr/lib/ubiquity/ubiquity/frontend/ | head
echo "=== query frontend ==="
/usr/bin/ubiquity -q 2>&1 | tail -2
echo "=== start-ubiquity-dm now? ==="
ls -la /usr/share/ubiquity/start-ubiquity-dm 2>/dev/null || echo "MISSING start-ubiquity-dm"
echo "=== ubiquity systemd/autostart now? ==="
find /usr/lib/ubiquity -maxdepth 2 -name "*.service" 2>/dev/null
dpkg -L ubiquity | grep -vE "doc|locale|\.mo$" | head -30
'