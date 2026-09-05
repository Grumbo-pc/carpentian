#!/bin/bash
# ============================================================
# Carpentian OS - Complete ISO Build Script
# Based on mvallim/live-custom-ubuntu-from-scratch
# ============================================================
set -e

BUILD_DIR="/root/carpentian-build"
CHROOT_DIR="$BUILD_DIR/chroot"
IMAGE_DIR="$BUILD_DIR/image"
MIRROR="http://us.archive.ubuntu.com/ubuntu"
SUITE="noble"
ARCH="amd64"
ISO_OUTPUT="/mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/Carpentian-OS.iso"
ASSETS="/mnt/d/carpentian theme"

echo "============================================"
echo "  Carpentian OS ISO Builder"
echo "============================================"

# ============================================================
# PHASE 1: Bootstrap Ubuntu 24.04
# ============================================================
echo "=====> Phase 1: Bootstrapping Ubuntu $SUITE..."
mkdir -p "$BUILD_DIR"
debootstrap --arch=$ARCH "$SUITE" "$CHROOT_DIR" "$MIRROR"

# ============================================================
# PHASE 2: Configure APT sources
# ============================================================
echo "=====> Phase 2: Configuring APT..."
cat > "$CHROOT_DIR/etc/apt/sources.list" << EOF
deb $MIRROR $SUITE main restricted universe multiverse
deb $MIRROR $SUITE-updates main restricted universe multiverse
deb $MIRROR $SUITE-security main restricted universe multiverse
EOF

# ============================================================
# PHASE 3: Mount virtual filesystems
# ============================================================
echo "=====> Phase 3: Mounting filesystems..."
mount --bind /dev "$CHROOT_DIR/dev"
mount --bind /dev/pts "$CHROOT_DIR/dev/pts"
mount -t proc proc "$CHROOT_DIR/proc"
mount -t sysfs sysfs "$CHROOT_DIR/sys"
mount -t tmpfs tmpfs "$CHROOT_DIR/run"
cp /etc/resolv.conf "$CHROOT_DIR/etc/resolv.conf"

# ============================================================
# PHASE 4: Install core packages
# ============================================================
echo "=====> Phase 4: Installing core packages..."
chroot "$CHROOT_DIR" apt-get update

# Core system
DEBIAN_FRONTEND=noninteractive chroot "$CHROOT_DIR" apt-get install -y \
    linux-image-generic \
    linux-headers-generic \
    casper \
    discover \
    laptop-detect \
    os-prober \
    network-manager \
    resolvconf \
    net-tools \
    wireless-tools \
    wpagui \
    locales \
    grub-common \
    grub-pc-bin \
    grub2-common \
    grub-pc \
    mtools \
    xorriso \
    live-boot \
    systemd-sysv \
    init \
    sudo \
    curl \
    wget

# Desktop environment - GNOME
echo "=====> Phase 5: Installing GNOME desktop..."
DEBIAN_FRONTEND=noninteractive chroot "$CHROOT_DIR" apt-get install -y \
    ubuntu-desktop-minimal \
    ubuntu-desktop \
    gnome-shell \
    gnome-session \
    gnome-terminal \
    gnome-control-center \
    gnome-system-monitor \
    gnome-tweaks \
    gnome-shell-extension-ubuntu-dock \
    gnome-shell-extension-appindicator \
    gdm3 \
    nautilus \
    file-roller \
    eog \
    evince \
    totem \
    rhythmbox \
    transmission-gtk \
    libreoffice-gtk3 \
    libreoffice-writer \
    libreoffice-calc \
    libreoffice-impress \
    simple-scan \
    baobab \
    gnome-characters \
    gnome-calculator \
    gnome-clocks \
    gnome-logs \
    gnome-font-viewer \
    gnome-text-editor \
    seahorse \
    synaptic \
    software-properties-gtk \
    update-manager \
    update-notifier \
    pulseaudio \
    pulseaudio-utils \
    alsa-utils \
    pavucontrol \
    xserver-xorg \
    xserver-xorg-video-all \
    xserver-xorg-input-all \
    xdg-desktop-portal-gnome \
    pipewire \
    wireplumber

# VMware guest tools
echo "=====> Phase 6: Installing VMware guest tools..."
DEBIAN_FRONTEND=noninteractive chroot "$CHROOT_DIR" apt-get install -y \
    open-vm-tools \
    open-vm-tools-desktop \
    xserver-xorg-video-vmware

# Utilities
DEBIAN_FRONTEND=noninteractive chroot "$CHROOT_DIR" apt-get install -y \
    neofetch \
    htop \
    vim \
    nano \
    git \
    build-essential \
    dkms \
    plymouth \
    plymouth-themes

# ============================================================
# PHASE 7: Install theme assets
# ============================================================
echo "=====> Phase 7: Installing Carpentian theme assets..."

# Wallpapers
mkdir -p "$CHROOT_DIR/usr/share/backgrounds/carpentian"
cp "$ASSETS/Backgrounds/"*.jpg "$CHROOT_DIR/usr/share/backgrounds/carpentian/"
cp "$ASSETS/Boot-Screen.jpeg" "$CHROOT_DIR/usr/share/backgrounds/carpentian/"
echo "  Wallpapers: OK"

# Icon theme
mkdir -p "$CHROOT_DIR/usr/share/icons/Carpentian-Gnome"
cp -r "$ASSETS/Carpentian-Gnome/scalable" "$CHROOT_DIR/usr/share/icons/Carpentian-Gnome/"
cp -r "$ASSETS/Carpentian-Gnome/symbolic" "$CHROOT_DIR/usr/share/icons/Carpentian-Gnome/"
cat > "$CHROOT_DIR/usr/share/icons/Carpentian-Gnome/index.theme" << 'ICONTHEME'
[Icon Theme]
Name=Carpentian-Gnome
Comment=Carpentian OS Icon Theme
Inherits=gnome,Adwaita,hicolor
Directories=scalable/places,scalable/devices,scalable/mimetypes,scalable/status,symbolic/actions,symbolic/categories,symbolic/devices,symbolic/emotes,symbolic/legacy,symbolic/mimetypes,symbolic/places,symbolic/status,symbolic/ui

[scalable/places]
Type=Scalable
Context=Places
MinSize=16
MaxSize=512
Size=48

[scalable/devices]
Type=Scalable
Context=Devices
MinSize=16
MaxSize=512
Size=48

[scalable/mimetypes]
Type=Scalable
Context=MimeTypes
MinSize=16
MaxSize=512
Size=48

[scalable/status]
Type=Scalable
Context=Status
MinSize=16
MaxSize=512
Size=48

[symbolic/actions]
Type=Scalable
Context=Actions
MinSize=16
MaxSize=512
Size=16

[symbolic/categories]
Type=Scalable
Context=Categories
MinSize=16
MaxSize=512
Size=16

[symbolic/devices]
Type=Scalable
Context=Devices
MinSize=16
MaxSize=512
Size=16

[symbolic/emotes]
Type=Scalable
Context=Emotes
MinSize=16
MaxSize=512
Size=16

[symbolic/legacy]
Type=Scalable
Context=Legacy
MinSize=16
MaxSize=512
Size=16

[symbolic/mimetypes]
Type=Scalable
Context=MimeTypes
MinSize=16
MaxSize=512
Size=16

[symbolic/places]
Type=Scalable
Context=Places
MinSize=16
MaxSize=512
Size=16

[symbolic/status]
Type=Scalable
Context=Status
MinSize=16
MaxSize=512
Size=16

[symbolic/ui]
Type=Scalable
Context=UI
MinSize=16
MaxSize=512
Size=16
ICONTHEME
echo "  Icons: OK"

# Cursor theme - Classic-Flat-White from tar
TMPDIR=$(mktemp -d)
tar xzf "$ASSETS/Carpentian-Gnome/Classic-Cursor.tar" -C "$TMPDIR"
mkdir -p "$CHROOT_DIR/usr/share/icons/Classic-Flat-White"
cp -r "$TMPDIR/Classic-Flat-White/"* "$CHROOT_DIR/usr/share/icons/Classic-Flat-White/"
cat > "$CHROOT_DIR/usr/share/icons/Classic-Flat-White/index.theme" << 'CURSORTHME'
[Icon Theme]
Name=Classic-Flat-White
Comment=Classic Flat White cursor theme for Carpentian OS
Inherits=Adwaita
Example=left_ptr
Directories=cursors

[cursors]
Type=Scalable
MinSize=16
MaxSize=512
CURSORTHME
rm -rf "$TMPDIR"
echo "  Cursors: OK"

# Sound theme
mkdir -p "$CHROOT_DIR/usr/share/sounds/Vicious"
cp -r "$ASSETS/Vicious/"* "$CHROOT_DIR/usr/share/sounds/Vicious/"
echo "  Sounds: OK"

# ============================================================
# PHASE 8: Create Windows 9x GTK theme
# ============================================================
echo "=====> Phase 8: Creating Windows 9x GTK theme..."
mkdir -p "$CHROOT_DIR/usr/share/themes/Carpentian-Win9x/gtk-3.0"
cat > "$CHROOT_DIR/usr/share/themes/Carpentian-Win9x/gtk-3.0/gtk.css" << 'GTKCSS'
/* Carpentian OS - Windows 9x inspired GTK theme */

/* Window decorations */
headerbar,
titlebar {
    background: linear-gradient(to bottom, #000080, #1084d0);
    color: white;
    border: none;
    box-shadow: none;
    padding: 2px 4px;
    min-height: 20px;
    font-weight: bold;
    font-size: 11px;
}

headerbar .title,
titlebar .title {
    color: white;
    font-weight: bold;
}

/* Window borders */
window,
dialog,
messagedialog {
    border: 2px solid #c0c0c0;
    border-radius: 0;
}

/* Buttons */
button {
    background: linear-gradient(to bottom, #dfdfdf, #c0c0c0);
    border: 1px solid #808080;
    border-radius: 0;
    padding: 2px 8px;
    min-height: 20px;
    color: black;
    box-shadow: inset 1px 1px 0 #ffffff, inset -1px -1px 0 #808080;
}

button:hover {
    background: linear-gradient(to bottom, #e8e8e8, #d0d0d0);
}

button:active {
    background: linear-gradient(to bottom, #b0b0b0, #c0c0c0);
    box-shadow: inset -1px -1px 0 #ffffff, inset 1px 1px 0 #808080;
}

/* Menus */
menu,
menuitem {
    background: #c0c0c0;
    color: black;
    border: 1px solid #808080;
}

menuitem:hover {
    background: #000080;
    color: white;
}

/* Scrollbar */
scrollbar {
    background: #c0c0c0;
    border: 1px solid #808080;
}

scrollbar slider {
    background: linear-gradient(to bottom, #dfdfdf, #c0c0c0);
    border: 1px solid #808080;
    min-width: 16px;
    min-height: 16px;
}

/* Text entries */
entry {
    background: white;
    border: 2px inset #c0c0c0;
    border-radius: 0;
    padding: 2px 4px;
    color: black;
}

/* Notebook/tabs */
notebook tab {
    background: #c0c0c0;
    border: 1px solid #808080;
    padding: 4px 8px;
    color: black;
}

notebook tab:checked {
    background: #dfdfdf;
    border-bottom-color: #dfdfdf;
}

/* Panel */
panel,
.top-bar,
.bottom-bar {
    background: linear-gradient(to bottom, #000080, #1084d0);
    color: white;
}

/* Sidebar/dash */
#dash {
    background: rgba(192, 192, 192, 0.95);
}

/* GTK2 legacy */
 GtkWidget {
    -GtkWidget-focus-line-width: 1;
    -GtkWidget-focus-padding: 0;
    -GtkWidget-internal-padding: 2;
}
GTKCSS
echo "  GTK theme: OK"

# ============================================================
# PHASE 9: OS Branding
# ============================================================
echo "=====> Phase 9: Branding..."

cat > "$CHROOT_DIR/etc/os-release" << 'OSRELEASE'
PRETTY_NAME="Carpentian OS"
NAME="Carpentian OS"
VERSION_ID="24.04"
VERSION="24.04 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=carpentian
ID_LIKE=ubuntu
HOME_URL=""
BUG_REPORT_URL=""
UBUNTU_CODENAME=noble
LOGO=carpentian-logo
OSRELEASE

cat > "$CHROOT_DIR/etc/lsb-release" << 'LSB'
DISTRIB_ID=Carpentian
DISTRIB_RELEASE=24.04
DISTRIB_CODENAME=noble
DISTRIB_DESCRIPTION="Carpentian OS 24.04 LTS"
LSB

cat > "$CHROOT_DIR/etc/issue" << 'ISSUE'
Carpentian OS \n \l

ISSUE
cp "$CHROOT_DIR/etc/issue" "$CHROOT_DIR/etc/issue.net"
echo "  Branding: OK"

# ============================================================
# PHASE 10: GNOME configuration
# ============================================================
echo "=====> Phase 10: Configuring GNOME..."

# dconf profile
mkdir -p "$CHROOT_DIR/etc/dconf/profile"
cat > "$CHROOT_DIR/etc/dconf/profile/user" << 'EOF'
user-db:user
system-db:local
EOF

# dconf defaults
mkdir -p "$CHROOT_DIR/etc/dconf/db/local.d"
cat > "$CHROOT_DIR/etc/dconf/db/local.d/01-carpentian" << 'DCONF'
[org/gnome/desktop/interface]
icon-theme='Carpentian-Gnome'
cursor-theme='Classic-Flat-White'
color-scheme='prefer-dark'
font-name='Sans 11'
document-font-name='Sans 11'
monospace-font-name='Monospace 12'
gtk-theme='Carpentian-Win9x'

[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/carpentian/Default1.jpg'
picture-uri-dark='file:///usr/share/backgrounds/carpentian/Default1.jpg'
picture-options='zoom'
primary-color='#000000'

[org/gnome/desktop/screensaver]
picture-uri='file:///usr/share/backgrounds/carpentian/LockScreen.jpg'
primary-color='#000000'

[org/gnome/shell]
enabled-extensions=['ubuntu-dock@ubuntu.com','appindicatorsupport@rgcjonas.gmail.com']
allowed-extensions=['ubuntu-dock@ubuntu.com','appindicatorsupport@rgcjonas.gmail.com']

[org/gnome/shell/extensions/ubuntu-dock]
dock-position='BOTTOM'
dash-max-icon-size=48
transparency-mode='FIXED'
background-opacity=80
show-trash=false
show-running=false
show-favorites=true
disable-overview-on-startup=true

[org/gnome/desktop/sound]
theme-name='Vicious'
event-sounds=true
input-feedback-sounds=true

[org/gnome/desktop/wm/preferences]
button-layout='close,minimize,maximize:appmenu'
titlebar-font='Sans Bold 11'

[org/gnome/desktop/session]
idle-delay=uint32 0

[org/gnome/screensaver]
idle-enabled=false
DCONF

# Lock some settings
mkdir -p "$CHROOT_DIR/etc/dconf/db/local.d/locks"
cat > "$CHROOT_DIR/etc/dconf/db/local.d/locks/00-locks" << 'LOCKS'
/org/gnome/desktop/background/picture-uri
/org/gnome/desktop/background/picture-uri-dark
/org/gnome/desktop/screensaver/picture-uri
/org/gnome/desktop/interface/icon-theme
/org/gnome/desktop/interface/cursor-theme
/org/gnome/desktop/sound/theme-name
/org/gnome/shell/extensions/ubuntu-dock/dock-position
LOCKS

# Autostart script - applies settings to live user session
mkdir -p "$CHROOT_DIR/etc/xdg/autostart"
cat > "$CHROOT_DIR/etc/xdg/autostart/carpentian-settings.desktop" << 'AUTOSTART'
[Desktop Entry]
Type=Application
Name=Carpentian Settings
Exec=/usr/bin/carpentian-apply-settings
X-GNOME-Autostart-enabled=true
NoDisplay=true
AUTOSTART

cat > "$CHROOT_DIR/usr/bin/carpentian-apply-settings" << 'APPLYSCRIPT'
#!/bin/bash
sleep 2
gsettings set org.gnome.desktop.interface icon-theme 'Carpentian-Gnome'
gsettings set org.gnome.desktop.interface cursor-theme 'Classic-Flat-White'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface font-name 'Sans 11'
gsettings set org.gnome/desktop/interface gtk-theme 'Carpentian-Win9x'
gsettings set org.gnome/desktop/background picture-uri 'file:///usr/share/backgrounds/carpentian/Default1.jpg'
gsettings set org.gnome/desktop/background picture-uri-dark 'file:///usr/share/backgrounds/carpentian/Default1.jpg'
gsettings set org.gnome/desktop/background picture-options 'zoom'
gsettings set org.gnome/desktop/screensaver picture-uri 'file:///usr/share/backgrounds/carpentian/LockScreen.jpg'
gsettings set org.gnome/shell extensions-list "['ubuntu-dock@ubuntu.com','appindicatorsupport@rgcjonas.gmail.com']"
gsettings set org.gnome.shell.extensions/ubuntu-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions/ubuntu-dock dash-max-icon-size 48
gsettings set org.gnome.shell.extensions/ubuntu-dock transparency-mode 'FIXED'
gsettings set org.gnome.shell.extensions/ubuntu-dock background-opacity 0.8
gsettings set org.gnome.shell.extensions/ubuntu-dock show-trash false
gsettings set org.gnome/shell favorite-apps "['firefox_firefox.desktop','org.gnome.Nautilus.desktop','org.gnome.Terminal.desktop']"
gsettings set org.gnome/desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'
gsettings set org.gnome/desktop/sound theme-name 'Vicious'
gsettings set org.gnome/desktop/sound event-sounds true
APPLYSCRIPT
chmod +x "$CHROOT_DIR/usr/bin/carpentian-apply-settings"

# GDM config - auto login, X11
cat > "$CHROOT_DIR/etc/gdm3/custom.conf" << 'GDM'
[daemon]
AutomaticLoginEnable=true
AutomaticLogin=ubuntu
WaylandEnable=false

[security]

[xdmcp]

[chooser]

[debug]
GDM

# PostLogin hook
mkdir -p "$CHROOT_DIR/etc/gdm3/PostLogin"
cat > "$CHROOT_DIR/etc/gdm3/PostLogin/Default" << 'POSTLOGIN'
#!/bin/bash
/usr/bin/carpentian-apply-settings &
POSTLOGIN
chmod +x "$CHROOT_DIR/etc/gdm3/PostLogin/Default"

# Update dconf database
mount --bind /dev "$CHROOT_DIR/dev" 2>/dev/null || true
mount -t proc proc "$CHROOT_DIR/proc" 2>/dev/null || true
chroot "$CHROOT_DIR" dconf update 2>/dev/null || true
umount "$CHROOT_DIR/proc" 2>/dev/null || true
umount "$CHROOT_DIR/dev" 2>/dev/null || true

echo "  GNOME config: OK"

# ============================================================
# PHASE 11: Plymouth boot splash
# ============================================================
echo "=====> Phase 11: Plymouth boot theme..."
mkdir -p "$CHROOT_DIR/usr/share/plymouth/themes/carpentian"
cp "$CHROOT_DIR/usr/share/backgrounds/carpentian/Boot-Screen.jpeg" "$CHROOT_DIR/usr/share/plymouth/themes/carpentian/background.jpg"
cat > "$CHROOT_DIR/usr/share/plymouth/themes/carpentian/carpentian.plymouth" << 'PLYM'
[Plymouth Theme]
Name=Carpentian
Description=Carpentian OS Boot Theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/carpentian
ScriptFile=/usr/share/plymouth/themes/carpentian/carpentian.script
PLYM
cat > "$CHROOT_DIR/usr/share/plymouth/themes/carpentian/carpentian.script" << 'PLYMSCR'
windowed_mode = 0;
disable_tracing = 1;
use_progress_log = 0;
message_font = "Mono 14";
title_font = "Sans Bold 16";
message_color = 1.0, 1.0, 1.0;
background = Image("background.jpg");
on boot (pid = 1) { Plymouth.MoveCursor(0, 0); }
on quit { }
PLYMSCR
ln -sf /usr/share/plymouth/themes/carpentian/carpentian.plymouth "$CHROOT_DIR/etc/alternatives/default.plymouth" 2>/dev/null || true
echo "  Plymouth: OK"

# ============================================================
# PHASE 12: Clean up chroot
# ============================================================
echo "=====> Phase 12: Cleaning up..."
chroot "$CHROOT_DIR" apt-get clean
chroot "$CHROOT_DIR" apt-get autoremove -y
rm -rf "$CHROOT_DIR/tmp/"* "$CHROOT_DIR/var/cache/apt/archives/"*.deb
rm -f "$CHROOT_DIR/etc/resolv.conf"
echo "nameserver 8.8.8.8" > "$CHROOT_DIR/etc/resolv.conf"

# ============================================================
# PHASE 13: Unmount and rebuild initramfs
# ============================================================
echo "=====> Phase 13: Rebuilding initramfs..."
mount --bind /dev "$CHROOT_DIR/dev" 2>/dev/null || true
mount --bind /dev/pts "$CHROOT_DIR/dev/pts" 2>/dev/null || true
mount -t proc proc "$CHROOT_DIR/proc" 2>/dev/null || true
mount -t sysfs sysfs "$CHROOT_DIR/sys" 2>/dev/null || true
mount -t tmpfs tmpfs "$CHROOT_DIR/run" 2>/dev/null || true
cp /etc/resolv.conf "$CHROOT_DIR/etc/resolv.conf"

# FIX: Add overlay, squashfs, loop modules so casper can mount /cow at boot
echo "  Adding overlay/squashfs/loop to initramfs-tools/modules..."
MODULES_FILE="$CHROOT_DIR/etc/initramfs-tools/modules"
for mod in overlay squashfs loop; do
    grep -q "^$mod" "$MODULES_FILE" 2>/dev/null || echo "$mod" >> "$MODULES_FILE"
done

# FIX: Auto-detect kernel version instead of hardcoding
KVER=$(ls "$CHROOT_DIR/boot/vmlinuz-"*-generic | sed 's|.*/vmlinuz-||' | sort -V | tail -1)
echo "  Detected kernel version: $KVER"
chroot "$CHROOT_DIR" update-initramfs -u -k "$KVER" 2>&1 | tail -3
umount "$CHROOT_DIR/proc" 2>/dev/null || true
umount "$CHROOT_DIR/sys" 2>/dev/null || true
umount "$CHROOT_DIR/dev/pts" 2>/dev/null || true
umount "$CHROOT_DIR/dev" 2>/dev/null || true
umount "$CHROOT_DIR/run" 2>/dev/null || true
echo "  initramfs: OK"

# ============================================================
# PHASE 14: Build image directory
# ============================================================
echo "=====> Phase 14: Building image directory..."
mkdir -p "$IMAGE_DIR"/{casper,isolinux,install}

cp "$CHROOT_DIR"/boot/vmlinuz-*-generic "$IMAGE_DIR/casper/vmlinuz"
cp "$CHROOT_DIR"/boot/initrd.img-*-generic "$IMAGE_DIR/casper/initrd"
touch "$IMAGE_DIR/ubuntu"

# GRUB config
cat > "$IMAGE_DIR/isolinux/grub.cfg" << 'GRUBCFG'
search --set=root --file /ubuntu
insmod all_video
set default="0"
set timeout=30

menuentry "Try Carpentian OS Without Installing" {
    linux /casper/vmlinuz boot=casper nopersistent toram quiet splash ---
    initrd /casper/initrd
}

menuentry "Install Carpentian OS" {
    linux /casper/vmlinuz boot=casper only-ubiquity quiet splash ---
    initrd /casper/initrd
}

menuentry "Try Carpentian OS (Safe Graphics)" {
    linux /casper/vmlinuz boot=casper nopersistent nomodeset quiet splash ---
    initrd /casper/initrd
}

menuentry "Debug Shell" {
    linux /casper/vmlinuz boot=casper nopersistent debug BOOT_DEBUG=1 ---
    initrd /casper/initrd
}
GRUBCFG

# Manifest
chroot "$CHROOT_DIR" dpkg-query -W --showformat='${Package} ${Version}\n' > "$IMAGE_DIR/casper/filesystem.manifest"
cp "$IMAGE_DIR/casper/filesystem.manifest" "$IMAGE_DIR/casper/filesystem.manifest-desktop"
for pkg in ubiquity casper discover laptop-detect os-prober; do
    sed -i "/$pkg/d" "$IMAGE_DIR/casper/filesystem.manifest-desktop"
done

# Disk defines
cat > "$IMAGE_DIR/README.diskdefines" << 'DISKDEF'
#define DISKNAME  Carpentian OS
#define TYPE  binary
#define TYPEbinary  1
#define ARCH  amd64
#define ARCHamd64  1
#define DISKNUM  1
#define DISKNUM1  1
#define TOTALNUM  0
#define TOTALNUM0  1
DISKDEF

# ============================================================
# PHASE 15: EFI and BIOS boot images
# ============================================================
echo "=====> Phase 15: Building boot images..."

# EFI
cp "$CHROOT_DIR/usr/lib/shim/shimx64.efi.signed" "$IMAGE_DIR/isolinux/bootx64.efi" 2>/dev/null || \
cp "$CHROOT_DIR/usr/lib/shim/shimx64.efi.signed.previous" "$IMAGE_DIR/isolinux/bootx64.efi" 2>/dev/null || \
cp "$CHROOT_DIR/usr/lib/shim/shimx64.efi" "$IMAGE_DIR/isolinux/bootx64.efi"
cp "$CHROOT_DIR/usr/lib/shim/mmx64.efi" "$IMAGE_DIR/isolinux/mmx64.efi"
cp "$CHROOT_DIR/usr/lib/grub/x86_64-efi-signed/grubx64.efi.signed" "$IMAGE_DIR/isolinux/grubx64.efi" 2>/dev/null || \
cp "$CHROOT_DIR/usr/lib/grub/x86_64-efi-signed/grubx64.efi" "$IMAGE_DIR/isolinux/grubx64.efi"

cd "$IMAGE_DIR/isolinux"
dd if=/dev/zero of=efiboot.img bs=1M count=10
mkfs.vfat -F 16 efiboot.img
LC_CTYPE=C mmd -i efiboot.img efi efi/ubuntu efi/boot
LC_CTYPE=C mcopy -i efiboot.img ./bootx64.efi ::efi/boot/bootx64.efi
LC_CTYPE=C mcopy -i efiboot.img ./mmx64.efi ::efi/boot/mmx64.efi
LC_CTYPE=C mcopy -i efiboot.img ./grubx64.efi ::efi/boot/grubx64.efi
LC_CTYPE=C mcopy -i efiboot.img ./grub.cfg ::efi/ubuntu/grub.cfg

# BIOS
grub-mkstandalone \
    --format=i386-pc \
    --output="$IMAGE_DIR/isolinux/core.img" \
    --install-modules="linux16 linux normal iso9660 biosdisk memdisk search tar ls" \
    --modules="linux16 linux normal iso9660 biosdisk search" \
    --locales="" \
    --fonts="" \
    "boot/grub/grub.cfg=$IMAGE_DIR/isolinux/grub.cfg"

cat "$CHROOT_DIR/usr/lib/grub/i386-pc/cdboot.img" "$IMAGE_DIR/isolinux/core.img" > "$IMAGE_DIR/isolinux/bios.img"

echo "  Boot images: OK"

# ============================================================
# PHASE 16: Squashfs
# ============================================================
echo "=====> Phase 16: Building squashfs..."
cd "$IMAGE_DIR"
mksquashfs "$CHROOT_DIR" "$IMAGE_DIR/casper/filesystem.squashfs" \
    -noappend -no-duplicates -no-recovery \
    -wildcards \
    -comp xz -b 1M -Xdict-size 100% \
    -e "var/cache/apt/archives/*" \
    -e "root/*" \
    -e "root/.*" \
    -e "tmp/*" \
    -e "tmp/.*" \
    -e "swapfile" \
    -e "proc/*" \
    -e "sys/*" \
    -e "dev/*" \
    -e "run/*" \
    -e "media/*" \
    -e "mnt/*" \
    -e "cdrom/*"

printf $(du -sx --block-size=1 "$CHROOT_DIR" | cut -f1) | tee "$IMAGE_DIR/casper/filesystem.size"

# md5sums
(find . -type f -print0 | xargs -0 md5sum | grep -v -e 'isolinux' > md5sum.txt)

echo "  Squashfs: OK"

# ============================================================
# PHASE 17: Build ISO
# ============================================================
echo "=====> Phase 17: Building ISO..."
xorriso \
    -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -J -J -joliet-long \
    -volid "Carpentian OS" \
    -output "$BUILD_DIR/Carpentian-OS.iso" \
    -eltorito-boot isolinux/bios.img \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        --eltorito-catalog boot.catalog \
        --grub2-boot-info \
        --grub2-mbr "$CHROOT_DIR/usr/lib/grub/i386-pc/boot_hybrid.img" \
        -partition_offset 16 \
        --mbr-force-bootable \
    -eltorito-alt-boot \
        -no-emul-boot \
        -e isolinux/efiboot.img \
        -append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b isolinux/efiboot.img \
        -appended_part_as_gpt \
        -iso_mbr_part_type a2a0d0ebe5b9334487c068b6b72699c7 \
        -m "isolinux/efiboot.img" \
        -m "isolinux/bios.img" \
        -e '--interval:appended_partition_2:::' \
    -exclude isolinux \
    -graft-points \
        "/EFI/boot/bootx64.efi=isolinux/bootx64.efi" \
        "/EFI/boot/mmx64.efi=isolinux/mmx64.efi" \
        "/EFI/boot/grubx64.efi=isolinux/grubx64.efi" \
        "/EFI/ubuntu/grub.cfg=isolinux/grub.cfg" \
        "/isolinux/bios.img=isolinux/bios.img" \
        "/isolinux/efiboot.img=isolinux/efiboot.img" \
        "."

cp "$BUILD_DIR/Carpentian-OS.iso" "$ISO_OUTPUT"
echo ""
echo "============================================"
echo "  ISO BUILT SUCCESSFULLY!"
echo "  Size: $(ls -lh "$ISO_OUTPUT" | awk '{print $5}')"
echo "  Location: $ISO_OUTPUT"
echo "============================================"
