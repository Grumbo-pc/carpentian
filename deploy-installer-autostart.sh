#!/bin/bash
# deploy-installer-autostart.sh - install autostart installer into chroot
C="/root/carpentian-build/chroot"
W="/mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian"

echo "=== install carpentian-installer.sh ==="
install -Dm755 "$W/carpentian-installer.sh" "$C/usr/local/sbin/carpentian-installer.sh"
echo "installed /usr/local/sbin/carpentian-installer.sh"

echo "=== install XDG autostart desktop file ==="
mkdir -p "$C/etc/xdg/autostart"
install -m644 "$W/carpentian-installer.desktop" "$C/etc/xdg/autostart/carpentian-installer.desktop"
echo "installed /etc/xdg/autostart/carpentian-installer.desktop"

echo "=== install polkit rules for passwordless ubiquity as live user ==="
install -Dm644 "$W/carpentian-install.pkla" "$C/etc/polkit-1/localauthority/50-local.d/carpentian-install.pkla"
echo "--- contents of pkla: ---"
cat "$C/etc/polkit-1/localauthority/50-local.d/carpentian-install.pkla"

echo "=== verify ==="
ls -la "$C/usr/local/sbin/carpentian-installer.sh"
ls -la "$C/etc/xdg/autostart/carpentian-installer.desktop"
ls -la "$C/etc/polkit-1/localauthority/50-local.d/carpentian-install.pkla"
echo "=== confirm ubiquity.service is DISABLED ==="
ls "$C/etc/systemd/system/graphical.target.wants/" 2>/dev/null | grep ubiquity || echo "no ubiquity.service (good)"
echo "=== DONE ==="