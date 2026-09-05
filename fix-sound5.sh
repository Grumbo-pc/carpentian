#!/bin/bash
set -e

# Verify full sound chain
echo "=== dconf sound settings ==="
grep -A4 "cinnamon/desktop/sounds" /root/carpentian-build/chroot/etc/dconf/db/local.d/01-carpentian

echo "=== Vicious theme ==="
cat /root/carpentian-build/chroot/usr/share/sounds/Vicious/index.theme

echo "=== canberra gtk module ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'ls /usr/lib/x86_64-linux-gnu/gtk-3.0/modules/libcanberra*'

echo "=== sound server packages ==="
chroot /root/carpentian-build/chroot /bin/bash -c 'dpkg -l pulseaudio pipewire wireplumber 2>/dev/null | grep "^ii"'

echo "=== event sounds enabled in dconf ==="
grep "event-sounds" /root/carpentian-build/chroot/etc/dconf/db/local.d/01-carpentian