#!/bin/bash
set -e
CHROOT=/root/carpentian-build/chroot

echo "=== 1. Kernel boot params for low-end hardware ==="
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nomodeset libata.force=noncpi acpi=off libapic=off noapic pci=noacpi mitigations=off taboot=force i8042.noloop clocksource=pitDivider=10"/' $CHROOT/etc/default/grub
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=2/' $CHROOT/etc/default/grub
echo "GRUB done"

echo "=== 2. Install zram-tools for compressed swap ==="
chroot $CHROOT /bin/bash -c 'apt-get install -y -qq zram-tools 2>/dev/null || true'
# Configure zram
cat > $CHROOT/etc/default/zramswap << 'ZRAM'
ALGO=zstd
PERCENT=50
PRIORITY=100
ZRAM
echo "zram done"

echo "=== 3. Sysctl tuning for low memory ==="
cat > $CHROOT/etc/sysctl.d/99-potato.conf << 'SYSCTL'
# Potato-mode sysctl: aggressive memory management for low-RAM systems
vm.swappiness=100
vm.dirty_ratio=5
vm.dirty_background_ratio=1
vm.vfs_cache_pressure=150
vm.min_free_kbytes=16
vm.overcommit_memory=1
vm.overcommit_ratio=80
vm.zone_reclaim_mode=0

# Reduce boot/readahead
vm.page-cluster=0

# Reduce network buffers (save memory)
net.core.rmem_max=262144
net.core.wmem_max=262144
net.ipv4.tcp_rmem=4096 87380 262144
net.ipv4.tcp_wmem=4096 65536 262144
net.core.netdev_max_backlog=16

# Console loglevel
kernel.printk = 4 4 1 7
SYSCTL
echo "sysctl done"

echo "=== 4. Disable heavy/unnecessary services ==="
chroot $CHROOT /bin/bash -c '
# Disable services not needed on potato hardware
for svc in bluetooth cups cups-browsed avahi-daemon colord \
    ModemManager networkd-dispatcher \
    switcheroo-control power-profiles-daemon \
    thermal-daemon rsyslog smartd ufw unattended-upgrades \
    packagekit ssh; do
  systemctl disable $svc 2>/dev/null || true
  systemctl mask $svc 2>/dev/null || true
done
echo "Services disabled"
'

echo "=== 5. Disable Cinnamon animations and effects ==="
mkdir -p $CHROOT/etc/dconf/db/local.d
cat > $CHROOT/etc/dconf/db/local.d/02-performance << 'DCONF'
[org/cinnamon]
desktop-effects-enabled=false
desktop-effects-run-speed=100
enable-animations=false

[org/cinnamon/desktop/interface]
gtk-theme='Carpentian-Win9x'
cursor-theme='Carpentian-cursors'
icon-theme='Carpentian-Gnome'

[org/cinnamon/cinnamon-extensions]
enabled-extensions=[]
DCONF

# Also create user overrides for Cinnamon settings
mkdir -p $CHROOT/etc/dconf/db/local.d/locks
cat > $CHROOT/etc/dconf/db/local.d/locks/02-locks << 'LOCKS'
/org/cinnamon/desktop-effects-enabled
/org/cinnamon/enable-animations
LOCKS
echo "Cinnamon effects disabled"

echo "=== 6. Reduce initramfs and modules ==="
# Tell the system to boot with fewer modules
mkdir -p $CHROOT/etc/initramfs-tools
echo 'MODULES=dep' > $CHROOT/etc/initramfs-tools/initramfs.conf
echo "initramfs trimmed"

echo "=== 7. Fstab: add tmpfs for /tmp and /var/tmp ==="
# Check if already has tmpfs entries
if ! grep -q 'tmpfs.*/tmp' $CHROOT/etc/fstab 2>/dev/null; then
  cat >> $CHROOT/etc/fstab << 'FSTAB'

# Potato-mode: tmpfs for temp dirs (saves disk I/O)
tmpfs /tmp tmpfs defaults,noatime,nosuid,nodev,size=256M 0 0
tmpfs /var/tmp tmpfs defaults,noatime,nosuid,nodev,size=128M 0 0
FSTAB
  echo "fstab updated"
else
  echo "fstab already has tmpfs"
fi

echo "=== 8. Kill dpkg-configure background noise ==="
# Reduce installed services count
chroot $CHROOT /bin/bash -c 'apt-get remove -y -qq whoopsie apport apport-gtk 2>/dev/null || true; apt-get purge -y -qq whoopsie apport apport-gtk 2>/dev/null || true'

echo "=== ALL OPTIMIZATIONS DONE ==="
