#!/bin/bash
sed -i 's/colors=(aqua white white white white white)/colors=(white white white white white white)/' \
    /root/carpentian-build/chroot/etc/neofetch/config.conf \
    /root/carpentian-build/chroot/root/.config/neofetch/config.conf \
    /root/carpentian-build/chroot/etc/skel/.config/neofetch/config.conf
echo "=== verify ==="
grep -n 'colors=' /root/carpentian-build/chroot/etc/neofetch/config.conf /root/carpentian-build/chroot/root/.config/neofetch/config.conf /root/carpentian-build/chroot/etc/skel/.config/neofetch/config.conf