#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== ubiquity gtk frontend ==="
ls /usr/lib/ubiquity/ubiquity/frontend/gtk_ui/ 2>/dev/null | head
echo "=== ubiquity bin/metainfo ==="
python3 -c "import ubiquity; print(ubiquity.__file__)" 2>&1
echo "=== /usr/bin/ubiquity ==="
cat /usr/bin/ubiquity 2>/dev/null | head -20
echo "=== ubiquity --query frontend ==="
/usr/bin/ubiquity -q 2>&1 | tail -3
'