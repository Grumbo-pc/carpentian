#!/usr/bin/env python3
"""Write all hook scripts for Carpentian OS ISO build."""
import os

BUILD = "/tmp/build-iso"
THEME = "/mnt/d/carpentian theme"
HOOKS = f"{BUILD}/config/hooks/normal"
os.makedirs(HOOKS, exist_ok=True)

# Hook 1: Copy theme assets into chroot
with open(f"{HOOKS}/0100-copy-theme.hook.chroot", "w") as f:
    f.write(f"""#!/bin/bash
set -e
THEME_DIR="{THEME}"
mkdir -p /opt/carpentian-theme
cp -r "$THEME_DIR/Backgrounds" /opt/carpentian-theme/ 2>/dev/null || true
cp -r "$THEME_DIR/Carpentian-Gnome" /opt/carpentian-theme/ 2>/dev/null || true
cp -r "$THEME_DIR/Vicious" /opt/carpentian-theme/ 2>/dev/null || true
cp "$THEME_DIR/Boot-Screen.jpeg" /opt/carpentian-theme/ 2>/dev/null || true
echo "Theme assets copied into chroot"
""")
os.chmod(f"{HOOKS}/0100-copy-theme.hook.chroot", 0o755)

# Hook 2: Install theme assets into system paths
with open(f"{HOOKS}/0200-install-theme.hook.chroot", "w") as f:
    f.write("""#!/bin/bash
set -e
echo "Installing Carpentian Theme..."

# Icons
mkdir -p /usr/share/icons/Carpentian-Gnome
cp -r /opt/carpentian-theme/Carpentian-Gnome/scalable /usr/share/icons/Carpentian-Gnome/ 2>/dev/null || true
cp -r /opt/carpentian-theme/Carpentian-Gnome/symbolic /usr/share/icons/Carpentian-Gnome/ 2>/dev/null || true
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

# Cursors
mkdir -p /usr/share/icons/Carpentian-cursors
cp -r /opt/carpentian-theme/Carpentian-Gnome/cursors/* /usr/share/icons/Carpentian-cursors/ 2>/dev/null || true
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

# Sounds
mkdir -p /usr/share/sounds/Vicious
cp -r /opt/carpentian-theme/Vicious/* /usr/share/sounds/Vicious/ 2>/dev/null || true

# Wallpapers
mkdir -p /usr/share/backgrounds/carpentian
cp /opt/carpentian-theme/Backgrounds/*.jpg /usr/share/backgrounds/carpentian/ 2>/dev/null || true
cp /opt/carpentian-theme/Boot-Screen.jpeg /usr/share/backgrounds/carpentian/ 2>/dev/null || true

echo "Theme installed"
""")
os.chmod(f"{HOOKS}/0200-install-theme.hook.chroot", 0o755)

# Hook 3: Create Win9x theme, neofetch config, GNOME dconf
with open(f"{HOOKS}/0300-configure-desktop.hook.chroot", "w") as f:
    f.write("""#!/bin/bash
set -e
echo "Configuring Carpentian Desktop..."

# Win9x GTK theme
mkdir -p /usr/share/themes/Carpentian-Win9x/gtk-3.0
cat > /usr/share/themes/Carpentian-Win9x/gtk-3.0/gtk.css << 'GTKCSS'
headerbar{background:linear-gradient(to right,#000080,#1084d0);border:2px solid #000;border-radius:0;min-height:28px;padding:2px;box-shadow:inset 1px 1px 0 #dfdfdf,inset -1px -1px 0 #808080}
headerbar .title{color:#fff;font-weight:bold}
window,dialog{border:3px solid #000;border-radius:0;box-shadow:inset 2px 2px 0 #dfdfdf,inset -2px -2px 0 #808080}
headerbar button{min-width:20px;min-height:20px;border:2px solid #000;border-radius:0;background:linear-gradient(to bottom,#dfdfdf,#c0c0c0);box-shadow:inset 1px 1px 0 #fff,inset -1px -1px 0 #808080}
headerbar button:hover{background:linear-gradient(to bottom,#e0e0e0,#d0d0d0)}
headerbar button:active{background:linear-gradient(to bottom,#a0a0a0,#c0c0c0)}
headerbar button.titlebutton.close{background:linear-gradient(to bottom,#ff6b6b,#c00)}
headerbar button.titlebutton.minimize{background:linear-gradient(to bottom,#ffd700,#c90)}
headerbar button.titlebutton.maximize{background:linear-gradient(to bottom,#90ee90,#0a0)}
menubar{background:#c0c0c0;border:2px solid #808080}
button{background:linear-gradient(to bottom,#dfdfdf,#c0c0c0);border:2px solid #000;border-radius:0;box-shadow:inset 1px 1px 0 #fff,inset -1px -1px 0 #808080}
entry{background:#fff;border:2px solid #808080;border-radius:0}
notebook tab{background:#c0c0c0;border:2px solid #000;border-radius:0}
notebook tab:checked{background:#dfdfdf}
GTKCSS

# Neofetch SC art
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

# Neofetch wrapper
cp /usr/bin/neofetch /usr/bin/neofetch.bin 2>/dev/null || true
cat > /usr/bin/neofetch << 'NEOF'
#!/bin/bash
exec /usr/bin/neofetch.bin --source /usr/share/neofetch/ascii/sc "$@"
NEOF
chmod +x /usr/bin/neofetch

# GNOME dconf
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

gtk-update-icon-cache -f -t /usr/share/icons/Carpentian-Gnome 2>/dev/null || true
echo "Desktop configured"
""")
os.chmod(f"{HOOKS}/0300-configure-desktop.hook.chroot", 0o755)

# Hook 4: Old hardware optimizations
with open(f"{HOOKS}/0400-oldhw-optimize.hook.chroot", "w") as f:
    f.write("""#!/bin/bash
set -e
echo "Applying old hardware optimizations..."

# Sysctl
mkdir -p /etc/sysctl.d
cat > /etc/sysctl.d/99-carpentian-oldhw.conf << 'SYSCTL'
vm.swappiness=60
vm.dirty_ratio=10
vm.dirty_background_ratio=5
vm.vfs_cache_pressure=50
vm.min_free_kbytes=16384
vm.zone_reclaim_mode=0
vm.page-cluster=3
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_congestion_control=bbr
vm.dirty_expire_centisecs=3000
vm.dirty_writeback_centisecs=500
kernel.sched_autogroup_enabled=0
SYSCTL

# TLP
cat > /etc/tlp.conf << 'TLP'
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_SCALING_MIN_FREQ_ON_AC=0
CPU_SCALING_MAX_FREQ_ON_AC=0
CPU_SCALING_MIN_FREQ_ON_BAT=0
CPU_SCALING_MAX_FREQ_ON_BAT=0
DISK_APM_LEVEL_ON_AC=128
DISK_APM_LEVEL_ON_BAT=128
SATA_LINKPWR_ON_AC=min_power
SATA_LINKPWR_ON_BAT=min_power
RUNTIME_PM_ON_AC=auto
RUNTIME_PM_ON_BAT=auto
WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=on
TLP

# ZRAM
cat > /etc/default/zramswap << 'ZRAM'
PERCENT=50
PRIORITY=100
ALGO=zstd
ZRAM

# Journald limit
mkdir -p /etc/systemd/journald.conf.d
cat > /etc/systemd/journald.conf.d/carpentian.conf << 'JOURNAL'
[Journal]
SystemMaxUse=50M
RuntimeMaxUse=10M
JOURNAL

# Disable heavy services
systemctl disable cups 2>/dev/null || true
systemctl disable cups-browsed 2>/dev/null || true
systemctl disable ModemManager 2>/dev/null || true
systemctl disable avahi-daemon 2>/dev/null || true
systemctl disable accounts-daemon 2>/dev/null || true
systemctl disable geoclue-daemon 2>/dev/null || true
systemctl disable rygel 2>/dev/null || true
systemctl disable whoopsie 2>/dev/null || true
systemctl disable apport 2>/dev/null || true
systemctl disable bluetooth 2>/dev/null || true
systemctl enable tlp 2>/dev/null || true
systemctl enable zramswap 2>/dev/null || true
systemctl enable fstrim.timer 2>/dev/null || true

# Faster GRUB
sed -i 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=3/' /etc/default/grub 2>/dev/null || true
sed -i 's/GRUB_TIMEOUT_STYLE=menu/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub 2>/dev/null || true
update-grub 2>/dev/null || true

echo "Old hardware optimizations applied"
""")
os.chmod(f"{HOOKS}/0400-oldhw-optimize.hook.chroot", 0o755)

print(f"All hooks written to {HOOKS}")
for f in sorted(os.listdir(HOOKS)):
    print(f"  {f}")
