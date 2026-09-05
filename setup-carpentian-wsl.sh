#!/bin/bash
# Carpentian OS WSL Setup Script
# This script applies the theme to your current Ubuntu WSL installation

set -e

THEME_DIR="/mnt/d/carpentian theme"

echo "=========================================="
echo "  Carpentian OS Theme Setup for WSL"
echo "=========================================="

# Check if theme directory exists
if [ ! -d "$THEME_DIR" ]; then
    echo "Error: Theme directory not found at $THEME_DIR"
    echo "Please make sure the D: drive is mounted in WSL"
    exit 1
fi

# Install required packages
echo "[1/8] Installing required packages..."
sudo apt-get update
sudo apt-get install -y gnome-shell gnome-shell-extensions gnome-tweaks \
    gnome-terminal neofetch fonts-liberation fonts-noto

# Install Carpentian icon theme
echo "[2/8] Installing Carpentian icon theme..."
if [ -d "$THEME_DIR/Carpentian-Gnome" ]; then
    sudo cp -r "$THEME_DIR/Carpentian-Gnome" /usr/share/icons/
    
    # Create index.theme if not exists
    if [ ! -f "/usr/share/icons/Carpentian-Gnome/index.theme" ]; then
        sudo tee /usr/share/icons/Carpentian-Gnome/index.theme > /dev/null << 'ICONTHEME'
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
ICONTHEME
    fi
    echo "  Icon theme installed successfully"
fi

# Install Carpentian cursor theme
echo "[3/8] Installing Carpentian cursor theme..."
if [ -d "$THEME_DIR/Carpentian-Gnome/cursors" ]; then
    sudo mkdir -p /usr/share/icons/Carpentian-cursors
    sudo cp -r "$THEME_DIR/Carpentian-Gnome/cursors"/* /usr/share/icons/Carpentian-cursors/
    
    sudo tee /usr/share/icons/Carpentian-cursors/index.theme > /dev/null << 'CURSORTHEME'
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
    echo "  Cursor theme installed successfully"
fi

# Install Vicious sound theme
echo "[4/8] Installing Vicious sound theme..."
if [ -d "$THEME_DIR/Vicious" ]; then
    sudo mkdir -p /usr/share/sounds/Vicious
    sudo cp -r "$THEME_DIR/Vicious"/* /usr/share/sounds/Vicious/
    echo "  Sound theme installed successfully"
fi

# Set up wallpapers
echo "[5/8] Setting up wallpapers..."
sudo mkdir -p /usr/share/backgrounds/carpentian
if [ -d "$THEME_DIR/Backgrounds" ]; then
    sudo cp "$THEME_DIR/Backgrounds"/*.jpg /usr/share/backgrounds/carpentian/ 2>/dev/null || true
    echo "  Wallpapers installed successfully"
fi

# Create Windows 9x GTK theme
echo "[6/8] Creating Windows 9x style theme..."
sudo mkdir -p /usr/share/themes/Carpentian-Win9x/gtk-3.0

sudo tee /usr/share/themes/Carpentian-Win9x/gtk-3.0/gtk.css > /dev/null << 'GTK3CSS'
/* Windows 9x Style Borders for Carpentian OS */

/* Window decoration - Windows 9x style */
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
window,
dialog {
    border: 3px solid #000000;
    border-radius: 0;
    box-shadow: inset 2px 2px 0 #dfdfdf, inset -2px -2px 0 #808080;
}

/* Title bar buttons - Windows 9x style */
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

/* Close button styling */
headerbar button.titlebutton.close {
    background: linear-gradient(to bottom, #ff6b6b, #cc0000);
    border-color: #000000;
}

headerbar button.titlebutton.close:hover {
    background: linear-gradient(to bottom, #ff8080, #ff0000);
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

/* Buttons - Windows 9x style */
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
GTK3CSS

echo "  Windows 9x theme created successfully"

# Configure GNOME settings
echo "[7/8] Configuring GNOME settings..."

# Set dock to bottom of screen
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM' 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED' 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.8 2>/dev/null || true

# Set window buttons to left (like Windows 9x style)
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:' 2>/dev/null || true

# Set themes
gsettings set org.gnome.desktop.interface gtk-theme 'Carpentian-Win9x' 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme 'Carpentian-Gnome' 2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-theme 'Carpentian-cursors' 2>/dev/null || true
gsettings set org.gnome.desktop.interface sound-theme 'Vicious' 2>/dev/null || true

# Set wallpaper
gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/carpentian/Default1.jpg" 2>/dev/null || true
gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/backgrounds/carpentian/Default1.jpg" 2>/dev/null || true

# Set lock screen
gsettings set org.gnome.desktop.screensaver picture-uri "file:///usr/share/backgrounds/carpentian/LockScreen.jpg" 2>/dev/null || true

echo "  GNOME settings configured successfully"

# Install custom neofetch configuration
echo "[8/8] Installing custom neofetch configuration..."
sudo mkdir -p /etc/neofetch

sudo tee /etc/neofetch/config.conf > /dev/null << 'NEOFETCHCONF'
# Carpentian OS Neofetch Configuration

# Title
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
ascii_distro="auto"
NEOFETCHCONF

# Create custom neofetch ASCII art
sudo mkdir -p /usr/share/neofetch/ascii
sudo tee /usr/share/neofetch/ascii/sc > /dev/null << 'SCASCII'
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

echo "  Neofetch configuration installed successfully"

echo ""
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""
echo "To apply all changes, please log out and log back in."
echo "Or run: gnome-session-quit --logout --no-prompt && startx"
echo ""
echo "To test neofetch with custom art:"
echo "  neofetch"
echo ""
echo "To change wallpaper, run:"
echo "  gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/carpentian/Default2.jpg'"
echo ""
