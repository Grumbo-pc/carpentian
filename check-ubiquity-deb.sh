#!/bin/bash
C=/root/carpentian-build/chroot
W=/tmp/ubiquity-deb-check
rm -rf $W && mkdir -p $W
chroot $C apt-get download ubiquity 2>/dev/null || cd /tmp
# apt download from host distro won't match; do it in chroot
cd $C/tmp 2>/dev/null || (mkdir -p $C/tmp)
chroot $C /bin/bash -c 'cd /tmp && apt-get download ubiquity >/dev/null 2>&1 && ls ubiquity_*.deb'
DEB=$(ls $C/tmp/ubiquity_*.deb 2>/dev/null | head -1)
echo "DEB=$DEB"
if [ -n "$DEB" ]; then
  dpkg-deb -c "$DEB" | grep "components/.*\.py$"
fi