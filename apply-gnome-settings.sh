#!/bin/bash
# Apply Carpentian OS GNOME settings
# Run this in a GNOME terminal session

echo "Applying Carpentian OS GNOME settings..."

# Icon theme
gsettings set org.gnome.desktop.interface icon-theme 'Carpentian-Gnome'

# Cursor theme
gsettings set org.gnome.desktop.interface cursor-theme 'Carpentian-cursors'

# GTK theme
gsettings set org.gnome.desktop.interface gtk-theme 'Carpentian-Win9x'

# Sound theme
gsettings set org.gnome.desktop.interface sound-theme 'Vicious'

# Window button layout (close, minimize, maximize on the left like Win9x)
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# Dock at bottom
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.8

# Wallpaper
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/carpentian/Default1.jpg'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/carpentian/Default1.jpg'

# Lock screen
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/carpentian/LockScreen.jpg'

echo "Done! All Carpentian OS settings applied."
echo "Run 'neofetch' to see the SC art."
