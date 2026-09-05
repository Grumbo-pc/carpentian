#!/bin/bash
set -e

# Reinstall alsa-base
chroot /root/carpentian-build/chroot /bin/bash -c '
apt-get install -y -qq alsa-base linux-sound-base 2>/dev/null || true
'

# Verify dconf has the sound theme set
chroot /root/carpentian-build/chroot /bin/bash -c '
grep -r "sound-theme" /etc/dconf/db/local.d/ 2>/dev/null
cat /etc/dconf/db/local.d/01-carpentian 2>/dev/null | grep sound
'

# Check if Vicious theme has the right structure
echo "=== Vicious theme structure ==="
ls -la /root/carpentian-build/chroot/usr/share/sounds/Vicious/
ls -la /root/carpentian-build/chroot/usr/share/sounds/Vicious/stereo/ 2>/dev/null | head -10

# Check index.theme
cat /root/carpentian-build/chroot/usr/share/sounds/Vicious/index.theme 2>/dev/null
