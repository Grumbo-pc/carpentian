#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
export PYTHONPATH=/usr/lib/ubiquity
echo "=== plugins present ==="
ls /usr/lib/ubiquity/plugins/*.py | sed "s|.*/||"
echo "=== expected core plugin set (from deb) ==="
dpkg -L ubiquity | grep "plugins/.*\.py$" | sed "s|.*/||"
echo "=== import all plugins ==="
for p in /usr/lib/ubiquity/plugins/*.py; do
  m=$(basename $p .py)
  python3 -c "import ubiquity.plugins.$m" 2>&1 | grep -E "Error|OK" >/dev/null && echo "OK  $m" || echo "WARN $m -> $(python3 -c 'import ubiquity.plugins.'$m 2>&1 | tail -1 | cut -c1-80)"
done
'