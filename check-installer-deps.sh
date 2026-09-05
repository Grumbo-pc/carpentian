#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "sudo=$(command -v sudo)"
echo "grub-install=$(command -v grub-install)"
echo "os-prober=$(command -v os-prober)"
echo "parted=$(command -v parted)"
echo "mkfs.ext4=$(command -v mkfs.ext4)"
for p in grub-pc grub-efi-amd64 os-prober parted btrfs-progs dosfstools cryptsetup; do
    if dpkg -l "$p" 2>/dev/null | grep -q ^ii; then
        echo "OK    $p"
    else
        echo "MISS  $p"
    fi
done
'