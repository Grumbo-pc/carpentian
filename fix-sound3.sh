#!/bin/bash
set -e
chroot /root/carpentian-build/chroot /bin/bash -c '
export DEBIAN_FRONTEND=noninteractive
dpkg --remove --force-remove-reinstreq memtest86+ 2>/dev/null || true
dpkg --purge memtest86+ 2>/dev/null || true
apt-get install -y -f -qq 2>&1 | tail -3
apt-get install -y -qq alsa-base linux-sound-base 2>&1 | tail -5
dpkg -l alsa-base linux-sound-base 2>/dev/null | tail -3
'