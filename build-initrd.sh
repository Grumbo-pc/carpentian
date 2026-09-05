#!/bin/bash
set -e
C=/root/carpentian-build/chroot

for d in proc sys dev; do
  [ -d "$C/$d" ] || mkdir -p "$C/$d"
  mountpoint -q "$C/$d" || mount --bind "/$d" "$C/$d"
done

sed -i 's/^MODULES=.*/MODULES=most/' "$C/etc/initramfs-tools/initramfs.conf"

KVER=$(ls "$C/boot/vmlinuz-"*-generic | sed "s|.*/vmlinuz-||;s|-generic||")
echo "KVER=$KVER"

chroot "$C" /bin/bash <<EOF
export DEBIAN_FRONTEND=noninteractive
rm -f /boot/initrd.img-$KVER-generic
mkinitramfs -o /boot/initrd.img-$KVER-generic $KVER-generic 2>&1 | tail -8
echo "=== result ==="
ls -lhL /boot/initrd.img-$KVER-generic
EOF

for d in dev proc sys; do
  mountpoint -q "$C/$d" && umount "$C/$d" || true
done
echo "=== DONE ==="