#!/bin/bash
set -e
chroot /root/carpentian-build/chroot /bin/bash -c '
export DEBIAN_FRONTEND=noninteractive
apt-get install -y -qq alsa-base linux-sound-base 2>&1 | tail -5
dpkg -l alsa-base linux-sound-base 2>/dev/null | tail -3
dpkg --audit 2>&1 | head -5
echo "=== sound theme test ==="
ls /usr/share/sounds/Vicious/index.theme
'