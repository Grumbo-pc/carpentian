#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
export PYTHONPATH=/usr/lib/ubiquity
echo "=== plugins __init__.py exists? ==="
ls /usr/lib/ubiquity/plugins/__init__.py 2>/dev/null && echo "yes" || echo "NO __init__.py (expected: plugininstall.py uses scan)";
grep -n "load_plugins\|glob\|\.py" /usr/lib/ubiquity/ubiquity/plugininstall.py | head
echo "=== frontend query ==="
python3 /usr/lib/ubiquity/bin/ubiquity -q 2>&1 | tail -3
echo "=== ubiquity-dm --help ==="
python3 /usr/bin/ubiquity-dm --help 2>&1 | head -8
'