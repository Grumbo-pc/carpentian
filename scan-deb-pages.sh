#!/bin/bash
DEB=/root/carpentian-build/chroot/tmp/ubiquity_24.04.5_amd64.deb
echo "=== page-name files in ubiquity deb ==="
dpkg-deb -c "$DEB" | grep -iE 'misc|user_setup|timezone|keyboard|language|console' | head -30
echo "=== all dirs mention components/files ==="
dpkg-deb -c "$DEB" | awk '{print $6}' | grep -vE 'lib$|bin$|/bin/' | grep -E 'files|component|locale|glade|ui' | head -20
echo "=== gtk_ui pages (Widgets) ==="
dpkg-deb -c "$DEB" | grep -iE '\.glade|widg|pages|step' | head