#!/bin/bash
C=/root/carpentian-build/chroot
echo "=== ubiquity-dm perms ==="
ls -la $C/usr/bin/ubiquity-dm
ls -la $C/usr/bin/X $C/usr/bin/Xorg 2>/dev/null
echo "=== X in squashfs? ==="
unsquashfs -ll /root/carpentian-build/image/casper/filesystem.squashfs "usr/bin/ubiquity-dm" 2>/dev/null | tail -2
echo "=== /usr/lib/ubiquity bin dir perms ==="
ls -la $C/usr/lib/ubiquity/bin/ubiquity
echo "=== splash/metacity/zenity/feh/xsettingsd present? ==="
for b in X Xorg metacity zenity feh xfsettingsd marco plymouth; do echo -n "$b: "; ls $C/usr/bin/$b $C/usr/sbin/$b 2>/dev/null | head -1 || echo MISSING; done
echo "=== does ubiquity gtk_ui actually run the 'only' path? chek gtk_ui.py step/exit ==="
grep -n "only\|expose_external\|not run_welcome" $C/usr/lib/ubiquity/ubiquity/frontend/gtk_ui.py | head