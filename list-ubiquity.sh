#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== all ubiquity-related binaries ==="
ls -la /usr/bin/*ubiquity* /usr/lib/ubiquity/bin/* 2>/dev/null
echo "=== python ubiquity modules ==="
ls /usr/lib/ubiquity/ubiquity/ 2>/dev/null | head -30
echo "=== gtk frontend ==="
find /usr/lib/ubiquity -type d -name "gtk_ui" 2>/dev/null
echo "=== dpkg -L ubiquity-frontend-gtk ==="
dpkg -L ubiquity-frontend-gtk 2>/dev/null | grep -v doc | head -40
echo "=== dpkg -L ubiquity (summary) ==="
dpkg -L ubiquity 2>/dev/null | grep -v doc | head -40
'