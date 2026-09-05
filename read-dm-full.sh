#!/bin/bash
C=/root/carpentian-build/chroot
echo "=== ubiquity-dm: full flow 240-430 ==="
sed -n '240,430p' $C/usr/bin/ubiquity-dm