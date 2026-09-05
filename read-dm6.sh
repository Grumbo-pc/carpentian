#!/bin/bash
C=/root/carpentian-build/chroot
echo "=== head 33-100 (pam conv, main) ==="
sed -n '33,100p' $C/usr/bin/ubiquity-dm
echo "=== tail: main / arg parsing ==="
tail -60 $C/usr/bin/ubiquity-dm