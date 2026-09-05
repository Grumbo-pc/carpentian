#!/bin/bash
# Carpentian OS - Old Hardware Optimized ISO Builder
# Designed for smooth operation on older PCs (2GB RAM, old CPUs, HDDs)

set -e

DISTRO_NAME="Carpentian OS"
WORKSPACE="$(pwd)/build-iso"
THEME_DIR="/mnt/d/carpentian theme"

echo "============================================"
echo "  $DISTRO_NAME - Old Hardware Edition"
echo "  Optimized for: 1-2GB RAM, old CPUs, HDDs"
echo "============================================"

if [ "$EUID" -ne 0 ]; then
    echo "Run as root: sudo ./build-iso-oldhw.sh"
    exit 1
fi

# Install live-build
apt-get update
apt-get install -y live-build debootstrap squashfs-tools \
    genisoimage xorriso grub-pc-bin grub-efi-amd64-bin \
    mtools dosfstools

# Clean old build
rm -rf "$WORKSPACE"
mkdir -p "$WORKSPACE"
cd "$WORKSPACE"

# ============================================
# CONFIGURE LIVE-BUILD
# ============================================
echo "[1/8] Configuring live-build..."

lb config noauto \
    --distribution noble \
    --architecture amd64 \
    --archive-areas "main restricted universe multiverse" \
    --bootloaders "grub-efi,grub-pc" \
    --memtest memtest86+ \
    --iso-application "$DISTRO_NAME" \
    --iso-publisher "$DISTRO_NAME" \
    --iso-volume "$DISTRO_NAME" \
    --bootappend-live "boot=live components quiet splash ramdisk-size=1024" \
    --apt-recommends false \
    --apt-secure true

mkdir -p config/package-lists

# ============================================
# MINIMAL PACKAGE LIST (OLD HARDWARE)
# ============================================
echo "[2/8] Creating minimal package list..."

cat > config/package-lists/carpentian.list.chroot << 'EOF'
# Core system - minimal
linux-generic
linux-headers-generic
firmware-linux
firmware-linux-nonfree
firmware-misc-nonfree
firmware-amd-graphics

# GNOME Flashback (lighter than full GNOME Shell)
gnome-session-flashback
gnome-panel
gnome-terminal
gnome-tweaks
gnome-screenshot
dconf-cli
dconf-editor

# Lightweight alternatives
xfce4-terminal
lxtask
htop

# Dash to Dock for GNOME Flashback
gnome-shell-extension-dash-to-dock

# Essential tools
sudo
curl
wget
git
vim
nano

# Neofetch
neofetch

# Audio
pulseaudio
pavucontrol
alsa-utils

# Power management (critical for old hardware/laptops)
tlp
tlp-rdw
powertop
laptop-mode-tools

# ZRAM for low RAM systems
zram-tools

# Hardware support
xserver-xorg
xserver-xorg-video-all
xserver-xorg-input-all
xinput
x11-xserver-utils

# Fonts
fonts-liberation
fonts-noto
fonts-noto-color-emoji
fonts-dejavu

# File manager with good performance
nemo
nemo-fileroller

# Browser
firefox

# Office (lightweight)
libreoffice-core
libreoffice-writer
libreoffice-calc
libreoffice-impress

# Codec support
gstreamer1.0-plugins-base
gstreamer1.0-plugins-good
gstreamer1.0-plugins-ugly
gstreamer1.0-libav

# Compression tools
unzip
p7zip-full

# System monitoring
inxi
lshw

# Old hardware specific
intel-microcode
amd64-microcode
thermald
cpufreqd
indicator-cpufreq

# Display manager (lightweight)
lightdm
lightdm-gtk-greeter

# Reduce unnecessary services
python3-minimal
EOF

# ============================================
# OLD HARDWARE OPTIMIZATIONS
# ============================================
echo "[3/8] Creating old hardware optimization scripts..."

mkdir -p config/includes.chroot/usr/local/bin
mkdir -p config/includes.chroot/etc/sysctl.d
mkdir -p config/includes.chroot/etc/systemd/system
mkdir -p config/includes.chroot/etc/udev/rules.d

# Kernel parameters for old hardware
cat > config/includes.chroot/etc/sysctl.d/99-carpentian-oldhw.conf << 'SYSCTL'
# Carpentian OS - Old Hardware Optimizations

# Memory management - optimize for low RAM
vm.swappiness=60
vm.dirty_ratio=10
vm.dirty_background_ratio=5
vm.vfs_cache_pressure=50
vm.min_free_kbytes=16384
vm.zone_reclaim_mode=0

# ZRAM settings
vm.page-cluster=3

# Network optimizations
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
net.ipv4.tcp_congestion_control=bbr

# Reduce disk I/O on HDDs
vm.dirty_expire_centisecs=3000
vm.dirty_writeback_centisecs=500

# Kernel - performance over security for old hardware
kernel.sysrq=1
kernel.sched_autogroup_enabled=0
SYSCTL

# TLP power management config
cat > config/includes.chroot/etc/tlp.conf << 'TLP'
# Carpentian OS - TLP Power Management for Old Hardware

CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave

CPU_SCALING_MIN_FREQ_ON_AC=0
CPU_SCALING_MAX_FREQ_ON_AC=0
CPU_SCALING_MIN_FREQ_ON_BAT=0
CPU_SCALING_MAX_FREQ_ON_BAT=0

CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power

DISK_APM_LEVEL_ON_AC="128"
DISK_APM_LEVEL_ON_BAT="128"

SATA_LINKPWR_ON_AC="min_power"
SATA_LINKPWR_ON_BAT="min_power"

RUNTIME_PM_ON_AC="auto"
RUNTIME_PM_ON_BAT="auto"

WIFI_PWR_ON_AC="off"
WIFI_PWR_ON_BAT="on"

SOUND_POWER_SAVE_ON_AC=1
SOUND_POWER_SAVE_ON_BAT=1
SOUND_POWER_SAVE_CONTROLLER=Y

TLP

# ZRAM configuration
cat > config/includes.chroot/etc/default/zramswap << 'ZRAM'
# Carpentian OS - ZRAM for low RAM systems
# Compress RAM to effectively double available memory
PERCENT=50
PRIORITY=100
ALGO=zstd
ZRAM

# Disable unnecessary services for old hardware
cat > config/includes.chroot/usr/local/bin/carpentian-oldhw-setup.sh << 'SETUP'
#!/bin/bash
# Carpentian OS - Post-install old hardware optimizations

echo "Applying old hardware optimizations..."

# Enable TLP for power management
systemctl enable tlp 2>/dev/null || true

# Enable ZRAM
systemctl enable zramswap 2>/dev/null || true

# Disable heavy services
systemctl disable cups 2>/dev/null || true
systemctl disable cups-browsed 2>/dev/null || true
systemctl disable bluetooth 2>/dev/null || true
systemctl disable ModemManager 2>/dev/null || true
systemctl disable avahi-daemon 2>/dev/null || true
systemctl disable accounts-daemon 2>/dev/null || true
systemctl disable geoclue-daemon 2>/dev/null || true
systemctl disable rygel 2>/dev/null || true
systemctl disable whoopsie 2>/dev/null || true
systemctl disable apport 2>/dev/null || true

# Reduce journal size
mkdir -p /etc/systemd/journald.conf.d
cat > /etc/systemd/journald.conf.d/carpentian.conf << 'JOURNAL'
[Journal]
SystemMaxUse=50M
RuntimeMaxUse=10M
JOURNAL

# Set CPU governor to performance on AC
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    if [ -w "$cpu" ]; then
        echo "powersave" > "$cpu" 2>/dev/null || true
    fi
done

# Enable TRIM for SSDs (if present)
systemctl enable fstrim.timer 2>/dev/null || true

# Set swappiness
sysctl vm.swappiness=60

# Reduce boot timeout
sed -i 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=3/' /etc/default/grub 2>/dev/null || true
sed -i 's/GRUB_TIMEOUT_STYLE=menu/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub 2>/dev/null || true
update-grub 2>/dev/null || true

echo "Old hardware optimizations applied!"
SETUP

chmod +x config/includes.chroot/usr/local/bin/carpentian-oldhw-setup.sh

# ============================================
# THEME ASSETS
# ============================================
echo "[4/8] Copying theme assets..."

mkdir -p config/includes.chroot/opt/carpentian-theme

if [ -d "$THEME_DIR/Backgrounds" ]; then
    cp -r "$THEME_DIR/Backgrounds" config/includes.chroot/opt/carpentian-theme/
fi
if [ -d "$THEME_DIR/Carpentian-Gnome" ]; then
    cp -r "$THEME_DIR/Carpentian-Gnome" config/includes.chroot/opt/carpentian-theme/
fi
if [ -d "$THEME_DIR/Vicious" ]; then
    cp -r "$THEME_DIR/Vicious" config/includes.chroot/opt/carpentian-theme/
fi
if [ -f "$THEME_DIR/Boot-Screen.jpeg" ]; then
    cp "$THEME_DIR/Boot-Screen.jpeg" config/includes.chroot/opt/carpentian-theme/
fi

# ============================================
# POST-INSTALL SCRIPT
# ============================================
echo "[5/8] Creating post-install script..."

cat > config/includes.chroot/usr/local/bin/carpentian-install.sh << 'INSTALL'
#!/bin/bash
THEME="/opt/carpentian-theme"

echo "Installing Carpentian OS theme..."

# Install icons
mkdir -p /usr/share/icons/Carpentian-Gnome
cp -r "$THEME/Carpentian-Gnome/scalable" /usr/share/icons/Carpentian-Gnome/
cp -r "$THEME/Carpentian-Gnome/symbolic" /usr/share/icons/Carpentian-Gnome/
cat > /usr/share/icons/Carpentian-Gnome/index.theme << 'ICONT'
[Icon Theme]
Name=Carpentian-Gnome
Comment=Carpentian OS Icon Theme
Inherits=Adwaita
Directories=scalable/devices,scalable/mimetypes,scalable/places,scalable/status
[scalable/devices]
Type=Scalable
Size=48
Context=Devices
[scalable/mimetypes]
Type=Scalable
Size=48
Context=MimeTypes
[scalable/places]
Type=Scalable
Size=48
Context=Places
[scalable/status]
Type=Scalable
Size=48
Context=Status
ICONT

# Install cursors
mkdir -p /usr/share/icons/Carpentian-cursors
cp -r "$THEME/Carpentian-Gnome/cursors"/* /usr/share/icons/Carpentian-cursors/
cat > /usr/share/icons/Carpentian-cursors/index.theme << 'CURST'
[Icon Theme]
Name=Carpentian-cursors
Comment=Carpentian OS Cursor Theme
Inherits=Adwaita
Directories=.
[.]
Type=Scalable
MinSize=16
MaxSize=512
CURST

# Install sounds
mkdir -p /usr/share/sounds/Vicious
cp -r "$THEME/Vicious"/* /usr/share/sounds/Vicious/

# Install wallpapers
mkdir -p /usr/share/backgrounds/carpentian
cp "$THEME/Backgrounds"/*.jpg /usr/share/backgrounds/carpentian/
cp "$THEME/Boot-Screen.jpeg" /usr/share/backgrounds/carpentian/

# Create Windows 9x theme
mkdir -p /usr/share/themes/Carpentian-Win9x/gtk-3.0
cat > /usr/share/themes/Carpentian-Win9x/gtk-3.0/gtk.css << 'GTKCSS'
headerbar {
    background: linear-gradient(to right, #000080, #1084d0);
    border: 2px solid #000000;
    border-radius: 0;
    min-height: 28px;
    padding: 2px;
    box-shadow: inset 1px 1px 0 #dfdfdf, inset -1px -1px 0 #808080;
}
headerbar .title {
    color: #ffffff;
    font-weight: bold;
}
window, dialog {
    border: 3px solid #000000;
    border-radius: 0;
    box-shadow: inset 2px 2px 0 #dfdfdf, inset -2px -2px 0 #808080;
}
headerbar button {
    min-width: 20px;
    min-height: 20px;
    border: 2px solid #000000;
    border-radius: 0;
    background: linear-gradient(to bottom, #dfdfdf, #c0c0c0);
    box-shadow: inset 1px 1px 0 #ffffff, inset -1px -1px 0 #808080;
}
headerbar button:hover {
    background: linear-gradient(to bottom, #e0e0e0, #d0d0d0);
}
headerbar button:active {
    background: linear-gradient(to bottom, #a0a0a0, #c0c0c0);
}
headerbar button.titlebutton.close {
    background: linear-gradient(to bottom, #ff6b6b, #cc0000);
}
headerbar button.titlebutton.minimize {
    background: linear-gradient(to bottom, #ffd700, #cc9900);
}
headerbar button.titlebutton.maximize {
    background: linear-gradient(to bottom, #90ee90, #00aa00);
}
menubar {
    background: #c0c0c0;
    border: 2px solid #808080;
}
button {
    background: linear-gradient(to bottom, #dfdfdf, #c0c0c0);
    border: 2px solid #000000;
    border-radius: 0;
    box-shadow: inset 1px 1px 0 #ffffff, inset -1px -1px 0 #808080;
}
entry {
    background: #ffffff;
    border: 2px solid #808080;
    border-radius: 0;
}
notebook tab {
    background: #c0c0c0;
    border: 2px solid #000000;
    border-radius: 0;
}
notebook tab:checked {
    background: #dfdfdf;
}
GTKCSS

# Create neofetch SC art
mkdir -p /usr/share/neofetch/ascii
cat > /usr/share/neofetch/ascii/sc << 'SCA'
                 ████████
               ██        ██
              ██          ██
             ██   ██████   ██
             ██  ██    ██  ██
             ██  ██    ██  ██
             ██  ██    ██  ██
             ██   ██████   ██
              ██          ██
               ██        ██
                 ████████

    ████████
   ██        ██
  ██          ██
 ██   ██████  ██
 ██  ██    ██ ██
 ██  ██    ████
 ██  ██    ██ ██
 ██   ██████  ██
  ██          ██
   ██        ██
    ████████
SCA

# Move neofetch binary for wrapper
if [ -f /usr/bin/neofetch ] && [ ! -f /usr/bin/neofetch.bin ]; then
    cp /usr/bin/neofetch /usr/bin/neofetch.bin
fi
cat > /usr/bin/neofetch << 'NEOF'
#!/bin/bash
exec /usr/bin/neofetch.bin --source /usr/share/neofetch/ascii/sc "$@"
NEOF
chmod +x /usr/bin/neofetch

# Apply GNOME settings
mkdir -p /etc/dconf/db/local.d
cat > /etc/dconf/db/local.d/01-carpentian << 'DCONF'
[org/gnome/desktop/interface]
icon-theme='Carpentian-Gnome'
cursor-theme='Carpentian-cursors'
gtk-theme='Carpentian-Win9x'
sound-theme='Vicious'
[org/gnome/desktop/wm/preferences]
button-layout='close,minimize,maximize:'
[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/carpentian/Default1.jpg'
picture-uri-dark='file:///usr/share/backgrounds/carpentian/Default1.jpg'
[org/gnome/desktop/screensaver]
picture-uri='file:///usr/share/backgrounds/carpentian/LockScreen.jpg'
[org/gnome/shell/extensions/dash-to-dock]
dock-position='BOTTOM'
dash-max-icon-size=uint32 48
dock-fixed=true
DCONF
dconf update

# Update caches
gtk-update-icon-cache -f -t /usr/share/icons/Carpentian-Gnome 2>/dev/null || true
update-desktop-database /usr/share/applications 2>/dev/null || true

echo "Carpentian OS theme installed!"
INSTALL

chmod +x config/includes.chroot/usr/local/bin/carpentian-install.sh

# First-boot hook
cat > config/includes.chroot/etc/rc.local << 'RCLOCAL'
#!/bin/bash
if [ ! -f /var/lib/carpentian-setup-done ]; then
    /usr/local/bin/carpentian-install.sh
    /usr/local/bin/carpentian-oldhw-setup.sh
    touch /var/lib/carpentian-setup-done
fi
exit 0
RCLOCAL
chmod +x config/includes.chroot/etc/rc.local

# ============================================
# GRUB CONFIG
# ============================================
echo "[6/8] Configuring GRUB..."

mkdir -p config/bootloaders/grub-efi
cat > config/bootloaders/grub-efi/grub.cfg << 'GRUBCFG'
set default=0
set timeout=3

menuentry "Carpentian OS (Old Hardware)" {
    linux /casper/vmlinuz boot=live components quiet splash ramdisk-size=1024
    initrd /casper/initrd
}

menuentry "Carpentian OS (Safe Graphics)" {
    linux /casper/vmlinuz boot=live components quiet splash nomodeset
    initrd /casper/initrd
}

menuentry "Carpentian OS (RAM Test)" {
    linux /memtest86+
}
GRUBCFG

# ============================================
# BUILD ISO
# ============================================
echo "[7/8] Building ISO..."
echo "This may take 15-30 minutes..."

lb build 2>&1 | tee ../build-iso.log

ISO_FILE=$(ls -1 *.iso 2>/dev/null | head -1)

if [ -n "$ISO_FILE" ]; then
    echo "[8/8] ISO built successfully!"
    echo ""
    echo "============================================"
    echo "  BUILD COMPLETE"
    echo "============================================"
    echo "  ISO File: $WORKSPACE/$ISO_FILE"
    echo "  Size: $(du -h "$ISO_FILE" | cut -f1)"
    echo ""
    echo "  To test in QEMU:"
    echo "    qemu-system-x86_64 -cdrom $ISO_FILE -m 2G -enable-kvm"
    echo ""
    echo "  To write to USB (Linux):"
    echo "    sudo dd if=$ISO_FILE of=/dev/sdX bs=4M status=progress"
    echo ""
    echo "  To write to USB (Windows):"
    echo "    Use Rufus or balenaEtcher"
    echo "============================================"
else
    echo "BUILD FAILED - check build-iso.log"
fi
