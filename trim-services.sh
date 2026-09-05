#!/bin/bash
set -e
CHROOT=/root/carpentian-build/chroot

echo "=== Remove snapd entirely ==="
chroot $CHROOT /bin/bash -c '
systemctl disable snapd 2>/dev/null || true
systemctl mask snapd 2>/dev/null || true
apt-get purge -y -qq snapd 2>/dev/null || true
rm -rf /snap /var/snap /var/lib/snapd
'

echo "=== Remove heavy packages ==="
chroot $CHROOT /bin/bash -c '
apt-get purge -y -qq \
    gnome-remote-desktop \
    open-vm-tools \
    openvpn \
    sssd \
    libsssd* \
    udisks2 \
    ubuntu-advantage-tools \
    linux-tools-* \
    linux-cloud-tools-* \
    2>/dev/null || true

# Remove docs and locale to save memory
rm -rf /usr/share/doc/* /usr/share/man/* /usr/share/info/* 2>/dev/null
rm -rf /usr/share/locale/* 2>/dev/null
mkdir -p /usr/share/locale/en
echo "Locale cleaned"
'

echo "=== Limit journal to 10MB ==="
mkdir -p $CHROOT/etc/systemd/journald.conf.d
cat > $CHROOT/etc/systemd/journald.conf.d/00-size.conf << 'CONF'
[Journal]
SystemMaxUse=10M
RuntimeMaxUse=10M
CONF

echo "=== Set Cinnamon to use less memory ==="
mkdir -p $CHROOT/etc/dconf/db/local.d
# Remove resource-heavy applets from panel  
cat > $CHROOT/etc/dconf/db/local.d/02-performance << 'DCONF'
[org/cinnamon]
desktop-effects-enabled=false
desktop-effects-run-speed=100
enable-animations=false
titlebar-font="Sans Bold 10"
default-font="Sans 10"
DCONF

echo "=== Done ==="
