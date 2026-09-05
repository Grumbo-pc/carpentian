#!/bin/bash
C=/root/carpentian-build/chroot
echo "=== actual files in chroot components dir ==="
ls $C/usr/lib/ubiquity/ubiquity/components/
echo "=== count ==="
ls $C/usr/lib/ubiquity/ubiquity/components/*.py | wc -l
echo "=== dpkg -L ubiquity count ==="
chroot $C dpkg -L ubiquity 2>/dev/null | grep -c "components/.*\.py$"
echo "=== what does apt list say ubiquity is? ==="
chroot $C apt-cache policy ubiquity 2>/dev/null | head -8
echo "=== does python import work for real frontend entry? datadir? ==="
chroot $C /bin/bash -c 'export PYTHONPATH=/usr/lib/ubiquity; python3 -c "
import ubiquity.components.install, ubiquity.components.grubinstaller, ubiquity.components.hw_detect, ubiquity.frontend
print(\"core components OK\")
"'