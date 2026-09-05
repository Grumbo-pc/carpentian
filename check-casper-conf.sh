#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== casper.conf in chroot rootfs ==="
cat /etc/casper.conf 2>/dev/null || echo "NO /etc/casper.conf"
echo "=== metacity binary (needed by ubiquity-dm WM list) ==="
command -v metacity marco xfwm4 matchbox-window-manager openbox compiz muffin 2>/dev/null
echo "=== muffin bin ==="
ls /usr/bin/muffin* 2>/dev/null
echo "=== ubiquity-dm WM lookup ==="
python3 -c "import sysconfig,os; print([os.path.exists(p) for p in [\"/usr/bin/metacity\",\"/usr/bin/marco\",\"/usr/bin/xfwm4\"]])"
echo "=== casper service / lightdm state ==="
systemctl is-enabled lightdm 2>&1 | tail -1
cat /etc/lightdm/lightdm.conf.d/10-carpetian.conf 2>/dev/null
cat /etc/lightdm/lightdm.conf 2>/dev/null | grep -vE "^#|^$" | head
'