#!/bin/bash
set -e

THEME="/mnt/d/carpentian theme"

echo "========================================="
echo "  Carpentian OS Theme Installer"
echo "========================================="

# Copy icons
echo "[1/6] Installing Carpentian icons..."
mkdir -p /usr/share/icons/Carpentian-Gnome
cp -r "$THEME/Carpentian-Gnome/scalable" /usr/share/icons/Carpentian-Gnome/
cp -r "$THEME/Carpentian-Gnome/symbolic" /usr/share/icons/Carpentian-Gnome/

cat > /usr/share/icons/Carpentian-Gnome/index.theme << 'ICONTHEME'
[Icon Theme]
Name=Carpentian-Gnome
Comment=Carpentian OS Icon Theme
Inherits=Adwaita
Directories=scalable/devices,scalable/mimetypes,scalable/places,scalable/status,actions,actions/activities,actions/categories,actions/devices,actions/emotes,actions/legacy,actions/mimetypes,actions/places,actions/status,actions/ui,devices,emotes,legacy,mimetypes,places,status,ui

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

[actions]
Context=Actions
Type=Scalable

[devices]
Context=Devices
Type=Scalable

[emotes]
Context=Emotes
Type=Scalable

[legacy]
Context=Legacy
Type=Scalable

[mimetypes]
Context=MimeTypes
Type=Scalable

[places]
Context=Places
Type=Scalable

[status]
Context=Status
Type=Scalable

[ui]
Context=UI
Type=Scalable
ICONTHEME

echo "  Icons installed"

# Copy cursors
echo "[2/6] Installing Carpentian cursors..."
mkdir -p /usr/share/icons/Carpentian-cursors
cp -r "$THEME/Carpentian-Gnome/cursors"/* /usr/share/icons/Carpentian-cursors/

cat > /usr/share/icons/Carpentian-cursors/index.theme << 'CURSORTHEME'
[Icon Theme]
Name=Carpentian-cursors
Comment=Carpentian OS Cursor Theme
Inherits=Adwaita
Directories=.

[.]
Type=Scalable
MinSize=16
MaxSize=512
CURSORTHEME

echo "  Cursors installed"

# Copy sound theme
echo "[3/6] Installing Vicious sound theme..."
mkdir -p /usr/share/sounds/Vicious
cp -r "$THEME/Vicious"/* /usr/share/sounds/Vicious/
echo "  Sounds installed"

# Copy wallpapers
echo "[4/6] Installing wallpapers..."
mkdir -p /usr/share/backgrounds/carpentian
cp "$THEME/Backgrounds"/*.jpg /usr/share/backgrounds/carpentian/
cp "$THEME/Boot-Screen.jpeg" /usr/share/backgrounds/carpentian/
echo "  Wallpapers installed"

# Create Windows 9x GTK theme
echo "[5/6] Creating Windows 9x GTK theme..."
mkdir -p /usr/share/themes/Carpentian-Win9x/gtk-3.0

cat > /usr/share/themes/Carpentian-Win9x/gtk-3.0/gtk.css << 'GTKCSS'
/* Carpentian OS - Windows 9x Style */

/* Title bar */
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
    text-shadow: 1px 1px 0 #000000;
}

/* Window borders */
window, dialog {
    border: 3px solid #000000;
    border-radius: 0;
    box-shadow: inset 2px 2px 0 #dfdfdf, inset -2px -2px 0 #808080;
}

/* Title bar buttons */
headerbar button {
    min-width: 20px;
    min-height: 20px;
    border: 2px solid #000000;
    border-radius: 0;
    background: linear-gradient(to bottom, #dfdfdf, #c0c0c0);
    box-shadow: inset 1px 1px 0 #ffffff, inset -1px -1px 0 #808080;
    padding: 2px;
}

headerbar button:hover {
    background: linear-gradient(to bottom, #e0e0e0, #d0d0d0);
}

headerbar button:active {
    background: linear-gradient(to bottom, #a0a0a0, #c0c0c0);
    box-shadow: inset 1px 1px 0 #808080, inset -1px -1px 0 #ffffff;
}

/* Close button */
headerbar button.titlebutton.close {
    background: linear-gradient(to bottom, #ff6b6b, #cc0000);
    border-color: #000000;
}

/* Minimize button */
headerbar button.titlebutton.minimize {
    background: linear-gradient(to bottom, #ffd700, #cc9900);
    border-color: #000000;
}

/* Maximize button */
headerbar button.titlebutton.maximize {
    background: linear-gradient(to bottom, #90ee90, #00aa00);
    border-color: #000000;
}

/* Menu bars */
menubar {
    background: #c0c0c0;
    border: 2px solid #808080;
    box-shadow: inset 1px 1px 0 #ffffff;
}

/* Status bar */
.statusbar {
    background: #c0c0c0;
    border: 2px solid #808080;
    box-shadow: inset 1px 1px 0 #ffffff;
}

/* Buttons */
button {
    background: linear-gradient(to bottom, #dfdfdf, #c0c0c0);
    border: 2px solid #000000;
    border-radius: 0;
    box-shadow: inset 1px 1px 0 #ffffff, inset -1px -1px 0 #808080;
    padding: 4px 8px;
}

button:hover {
    background: linear-gradient(to bottom, #e0e0e0, #d0d0d0);
}

button:active {
    background: linear-gradient(to bottom, #a0a0a0, #c0c0c0);
    box-shadow: inset 1px 1px 0 #808080, inset -1px -1px 0 #ffffff;
}

/* Entry fields */
entry {
    background: #ffffff;
    border: 2px solid #808080;
    border-radius: 0;
    box-shadow: inset 1px 1px 0 #404040;
    padding: 4px;
}

/* Scrollbars */
scrollbar slider {
    background: linear-gradient(to bottom, #dfdfdf, #c0c0c0);
    border: 2px solid #000000;
    border-radius: 0;
    box-shadow: inset 1px 1px 0 #ffffff;
}

/* Notebook tabs */
notebook tab {
    background: #c0c0c0;
    border: 2px solid #000000;
    border-radius: 0;
    box-shadow: inset 1px 1px 0 #ffffff;
}

notebook tab:checked {
    background: #dfdfdf;
    box-shadow: inset 1px 1px 0 #ffffff, inset -1px 0 0 #ffffff;
}

/* Frames */
frame {
    border: 2px solid #808080;
    border-radius: 0;
    box-shadow: inset 1px 1px 0 #ffffff;
}

/* Sidebar / dock background */
.bottom-bar, .dash-background, .dash-bottom-bar {
    background-color: rgba(192, 192, 192, 0.85);
    border-top: 2px solid #808080;
}
GTKCSS

echo "  Windows 9x theme created"

# Install neofetch config with SC art
echo "[6/6] Installing neofetch config..."
mkdir -p /etc/neofetch

cat > /etc/neofetch/config.conf << 'NEOFETCHCONF'
title_fqdn="off"
kernel_shorthand="on"
distro_shorthand="off"
os_arch="on"
uptime_shorthand="tiny"
memory_percent="off"
memory_unit="gib"
package_managers="on"
shell_path="off"
shell_version="on"
speed_type="bioslimit"
speed_shorthand="on"
colors=(distro)
bold="on"
underline_enabled="on"
underline_char="-"
separator=":"
color_blocks="on"
block_range=(1 16)
block_width=3
block_distance=1
block_color="auto"
ascii_colors=(distro)
ascii_distro="sc"
NEOFETCHCONF

mkdir -p /usr/share/neofetch/ascii

cat > /usr/share/neofetch/ascii/sc << 'SCASCII'
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
SCASCII

echo "  Neofetch config installed"

# Update icon cache
echo "Updating icon cache..."
gtk-update-icon-cache -f -t /usr/share/icons/Carpentian-Gnome 2>/dev/null || true
gtk-update-icon-cache -f -t /usr/share/icons/Carpentian-cursors 2>/dev/null || true

echo ""
echo "========================================="
echo "  Installation Complete!"
echo "========================================="
echo ""
echo "To apply the theme, run these commands:"
echo ""
echo "  gsettings set org.gnome.desktop.interface icon-theme 'Carpentian-Gnome'"
echo "  gsettings set org.gnome.desktop.interface cursor-theme 'Carpentian-cursors'"
echo "  gsettings set org.gnome.desktop.interface gtk-theme 'Carpentian-Win9x'"
echo "  gsettings set org.gnome.desktop.interface sound-theme 'Vicious'"
echo "  gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'"
echo "  gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'"
echo ""
echo "To set wallpaper:"
echo "  gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/carpentian/Default1.jpg'"
echo "  gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/carpentian/Default1.jpg'"
echo ""
echo "To see the SC art:"
echo "  neofetch"
echo ""
