#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== is carpentian in sudo group? ==="
getent group sudo
id carpentian
echo "=== 44pk_allow_ubuntu hook (pkexec allow) ==="
cat /usr/share/initramfs-tools/scripts/casper-bottom/44pk_allow_ubuntu 2>/dev/null | head -30
'