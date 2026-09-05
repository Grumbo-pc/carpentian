#!/bin/bash
# Carpentian OS Theme Switcher
# Switch between different wallpaper options

WALLPAPER_DIR="/usr/share/backgrounds/carpentian"

echo "=========================================="
echo "  Carpentian OS Theme Switcher"
echo "=========================================="
echo ""
echo "Available wallpapers:"
echo "1. Default1.jpg"
echo "2. Default2.jpg"
echo "3. Default3.jpg"
echo "4. Default4.jpg"
echo "5. Default5.jpg"
echo "6. Lock Screen (LockScreen.jpg)"
echo "7. Restore default theme"
echo "8. Exit"
echo ""

read -p "Select a wallpaper (1-8): " choice

case $choice in
    1)
        gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DIR/Default1.jpg"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_DIR/Default1.jpg"
        echo "Wallpaper changed to Default1.jpg"
        ;;
    2)
        gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DIR/Default2.jpg"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_DIR/Default2.jpg"
        echo "Wallpaper changed to Default2.jpg"
        ;;
    3)
        gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DIR/Default3.jpg"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_DIR/Default3.jpg"
        echo "Wallpaper changed to Default3.jpg"
        ;;
    4)
        gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DIR/Default4.jpg"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_DIR/Default4.jpg"
        echo "Wallpaper changed to Default4.jpg"
        ;;
    5)
        gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DIR/Default5.jpg"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_DIR/Default5.jpg"
        echo "Wallpaper changed to Default5.jpg"
        ;;
    6)
        gsettings set org.gnome.desktop.screensaver picture-uri "file://$WALLPAPER_DIR/LockScreen.jpg"
        echo "Lock screen changed to LockScreen.jpg"
        ;;
    7)
        gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
        gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
        gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
        gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/warty-final-ubuntu.png"
        gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/backgrounds/warty-final-ubuntu.png"
        echo "Theme restored to default Ubuntu theme"
        ;;
    8)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "Theme updated successfully!"
echo "Changes will take effect immediately for most settings."
echo "For full effect, log out and back in."
