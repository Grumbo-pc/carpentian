#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== sources.list in live system (target copy source) ==="
cat /etc/apt/sources.list 2>/dev/null | grep -v "^#"
cat /etc/apt/sources.list.d/*.sources 2>/dev/null | grep -v "^#" | grep -E "URIs|Suites|Components" | head -20
echo "=== 41apt_cdrom hook (sets cdrom apt source at boot) ==="
cat /usr/share/initramfs-tools/scripts/casper-bottom/41apt_cdrom 2>/dev/null | head -40
echo "=== install.py lines 200-320 (manifest + keep/archive logic) ==="
sed -n "200,340p" /usr/share/ubiquity/install.py
'