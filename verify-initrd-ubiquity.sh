#!/bin/bash
C=/root/carpentian-build/chroot
DEP=/tmp/initrd-verify
rm -rf $DEP; mkdir -p $DEP
cd $DEP
echo "=== extract rebuilt initrd ($(ls $C/boot/initrd.img-*-generic)) ==="
unmkinitramfs $C/boot/initrd.img-6.8.0-138-generic "$DEP/main" 2>/dev/null
ls -la "$DEP/main/scripts/" | grep -i casper
echo "--- casper-bottom hooks present ---"
ls "$DEP/main/scripts/casper-bottom/" | sort | tr '\n' ' '
echo ""
echo "--- ubiquity in initrd? ---"
grep -rln "ubiquity" "$DEP/main" 2>/dev/null | head
echo "=== sudoers for live user ==="
cat $C/etc/sudoers 2>/dev/null | grep -v "^#"
ls $C/etc/sudoers.d/ 2>/dev/null
echo "=== pkexec policy ==="
ls $C/usr/share/polkit-1/actions/ 2>/dev/null | grep -i ubiquity