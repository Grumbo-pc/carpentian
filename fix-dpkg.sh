#!/bin/bash
C=/root/carpentian-build/chroot

for d in proc sys dev; do
  [ -d "$C/$d" ] || mkdir -p "$C/$d"
  mountpoint -q "$C/$d" || mount --bind "/$d" "$C/$d"
done

chroot "$C" /bin/bash <<'EOF'
export DEBIAN_FRONTEND=noninteractive
echo "=== remaining broken packages ==="
dpkg --audit 2>&1 | head
echo "=== try configure -a (noninteractive, skip grub hooks that fail on efivars) ; expect initramfs/grub failure but others configure ==="
dpkg --configure -a 2>&1 | grep -iE "error|Setting up" | head -40
echo "=== verify final ubiquity state ==="
dpkg -l ubiquity ubiquity-frontend-gtk ubiquity-casper ubiquity-ubuntu-artwork 2>/dev/null | grep ^ii
EOF

for d in dev proc sys; do
  mountpoint -q "$C/$d" && umount "$C/$d" || true
done
echo "=== DONE ==="