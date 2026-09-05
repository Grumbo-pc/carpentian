#!/bin/bash
set -e
C=/root/carpentian-build/chroot

# Bind-mount proc/sys/dev so update-initramfs & postinst run clean
for d in proc sys dev; do
  [ -d "$C/$d" ] || mkdir -p "$C/$d"
  mountpoint -q "$C/$d" || mount --bind "/$d" "$C/$d"
done

chroot "$C" /bin/bash <<'EOF'
export DEBIAN_FRONTEND=noninteractive
dpkg --configure -a 2>&1 | tail -5
rm -f /boot/initrd.img-*
update-initramfs -u -k all 2>&1 | tail -6
echo "=== initrd rebuilt ==="
ls -lh /boot/initrd.img-* 2>/dev/null
EOF

# unmount
for d in dev proc sys; do
  mountpoint -q "$C/$d" && umount "$C/$d" || true
done
echo "=== DONE fixing initramfs ==="