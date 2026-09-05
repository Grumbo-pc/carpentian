#!/bin/bash
sed -i 's/ascii_colors=(7 1 7 7 7 7)/ascii_colors=(7 7 7 7 7 7)/' \
    /root/carpentian-build/chroot/root/.config/neofetch/config.conf \
    /root/carpentian-build/chroot/etc/skel/.config/neofetch/config.conf
echo "=== verify ==="
grep -n 'colors' /root/carpentian-build/chroot/root/.config/neofetch/config.conf /root/carpentian-build/chroot/etc/skel/.config/neofetch/config.conf