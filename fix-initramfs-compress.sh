#!/bin/bash
echo "COMPRESS=xz" >> /root/carpentian-build/chroot/etc/initramfs-tools/initramfs.conf
chroot /root/carpentian-build/chroot /bin/bash -c 'dpkg --configure initramfs-tools 2>&1 | tail -3'