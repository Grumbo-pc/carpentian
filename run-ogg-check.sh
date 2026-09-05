#!/bin/bash
cp /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/check-ogg.py /root/carpentian-build/chroot/tmp/check-ogg.py
chroot /root/carpentian-build/chroot python3 /tmp/check-ogg.py
rm -f /root/carpentian-build/chroot/tmp/check-ogg.py