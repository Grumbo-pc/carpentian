#!/bin/bash
# 01-build-chroot.sh - Build the Carpentian root filesystem (stage1)
# Run inside WSL Ubuntu (root), same architecture as target (amd64).
# Creates the chroot that becomes the full desktop system.
set -euo pipefail

BUILD=/root/carpentian-build
CHROOT=$BUILD/chroot
RELEASE=noble
MIRROR=http://us.archive.ubuntu.com/ubuntu

echo "### debootstrap base system"
if [ ! -d "$CHROOT/etc" ]; then
    debootstrap --arch=amd64 --components=main,restricted,universe,multiverse \
        --include=systemd,sudo,locales,networkd-dispatcher,ubuntu-minimal \
        "$RELEASE" "$CHROOT" "$MIRROR"
fi

# Nameserver for live session (systemd-resolved writes /run/...)
mkdir -p "$CHROOT/etc/systemd/resolved.conf.d"

echo "### DONE: chroot base at $CHROOT"
echo "Next: 02-config-chroot.sh (inside chroot) then 03-customize.sh"
