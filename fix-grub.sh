#!/bin/bash
sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nomodeset mitigations=off"|' /root/carpentian-build/chroot/etc/default/grub
grep GRUB_CMDLINE /root/carpentian-build/chroot/etc/default/grub
