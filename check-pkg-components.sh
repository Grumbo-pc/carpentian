#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== ubiquity package ships these components ==="
dpkg -L ubiquity | grep "components/.*py$"
echo "=== are the others in a different pkg? ==="
dpkg -S /usr/lib/ubiquity/ubiquity/components/misc.py 2>&1
dpkg -S /usr/lib/ubiquity/ubiquity/components/timezone.py 2>&1
echo "=== components binary dir ==="
dpkg -L ubiquity | grep -E "bin/" | head -40
'