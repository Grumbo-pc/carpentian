#!/bin/bash
THEME=/root/carpentian-build/chroot/usr/share/icons/Carpentian-Gnome/symbolic
echo "=== Missing symbolic icons ==="
for icon in preferences-system system-lock-screen system-switch-user logout system-shutdown; do
    if [ -f "$THEME/actions/${icon}-symbolic.svg" ] || [ -f "$THEME/status/${icon}-symbolic.svg" ] || [ -f "$THEME/categories/${icon}-symbolic.svg" ] || [ -f "$THEME/legacy/${icon}-symbolic.svg" ]; then
        echo "  FOUND: $icon"
    else
        echo "  MISSING: $icon"
        find /root/carpentian-build/chroot/usr/share/icons/ -name "${icon}-symbolic.svg" 2>/dev/null | head -1
    fi
done
echo ""
echo "=== User applet has its own icons ==="
ls /root/carpentian-build/chroot/usr/share/cinnamon/applets/user@cinnamon.org/icons/
