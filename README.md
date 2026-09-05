# Carpentian OS

A custom Linux distribution based on Ubuntu LTS with GNOME desktop, featuring Windows 9x style window borders and a complete custom theme.

## Features

- **Base**: Ubuntu 24.04 LTS
- **Desktop**: GNOME with dock at bottom of screen
- **Window Borders**: Windows 9x style with beveled edges and gradient title bars
- **Custom Theme**: Complete icon, cursor, and sound theme
- **Boot Screen**: Custom splash image
- **Neofetch Art**: Custom "SC" ASCII art

## Assets

All theme assets are located in `D:\carpentian theme`:

- **Backgrounds**: 5 desktop wallpapers + 1 lock screen image
- **Boot-Screen.jpeg**: Custom boot splash image
- **Carpentian-Gnome**: 616 SVG icons (scalable + symbolic) + 68 cursor files
- **Vicious**: 47 sound effects covering all system events

## Installation Options

### Option 1: Test in WSL (Recommended First Step)

1. Make sure WSL is installed with Ubuntu
2. Open WSL terminal
3. Run the setup script:

```bash
cd /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian
chmod +x setup-carpentian-wsl.sh
./setup-carpentian-wsl.sh
```

4. Log out and log back in to apply changes
5. Run `neofetch` to see the custom ASCII art

### Option 2: Build Custom ISO

1. Open WSL terminal with root access:

```bash
sudo bash
```

2. Navigate to the project:

```bash
cd /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian
```

3. Run the build script:

```bash
chmod +x build-carpentian.sh
./build-carpentian.sh
```

4. Build the ISO:

```bash
sudo ./build-iso.sh
```

5. The ISO will be created in the `build/` directory

### Option 3: Test ISO in QEMU

After building the ISO, test it in a virtual machine:

```bash
# Install QEMU
sudo apt install qemu-system-x86

# Run the ISO
qemu-system-x86_64 -cdrom build/carpentian-*.iso -m 4G -enable-kvm
```

## Customization

### Changing Wallpaper

```bash
gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/carpentian/Default2.jpg"
```

Available wallpapers:
- Default1.jpg through Default5.jpg
- LockScreen.jpg (for lock screen)

### GNOME Dock Settings

The dock is configured to appear at the bottom of the screen. To modify:

```bash
# Change dock position
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'

# Change icon size
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48

# Toggle dock visibility
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
```

### Window Border Style

The Windows 9x theme is applied as `Carpentian-Win9x`. To switch themes:

```bash
# Apply Windows 9x theme
gsettings set org.gnome.desktop.interface gtk-theme 'Carpentian-Win9x'

# Switch back to default
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
```

### Neofetch

Run neofetch to see the custom "SC" ASCII art:

```bash
neofetch
```

## File Structure

```
carpentian/
├── build-carpentian.sh          # Main build script
├── build-iso.sh                 # ISO creation script
├── setup-carpentian-wsl.sh      # WSL setup script
├── README.md                    # This file
├── build.log                    # Build log (after building)
└── build/                       # Build output directory
    └── carpentian-*.iso         # Generated ISO file
```

## Troubleshooting

### Theme not applying

1. Make sure you logged out and back in
2. Check if the theme files are in the correct location:

```bash
ls -la /usr/share/icons/Carpentian-Gnome/
ls -la /usr/share/themes/Carpentian-Win9x/
```

### Dock not appearing at bottom

1. Install GNOME Shell extensions:

```bash
sudo apt install gnome-shell-extensions
```

2. Enable Dash to Dock extension:

```bash
gnome-extensions enable dash-to-dock@micxgx.gmail.com
```

### Neofetch not showing custom art

1. Check if the ASCII art file exists:

```bash
ls -la /usr/share/neofetch/ascii/sc
```

2. If not, reinstall the setup script

## Building for Production

For a production-ready ISO:

1. Update the preseed configuration in `config/includes.installer/preseed.cfg`
2. Change the default password (currently a placeholder)
3. Add any additional packages you need
4. Test the ISO in a virtual machine before deploying

## Credits

- Base: Ubuntu 24.04 LTS
- Desktop: GNOME
- Sound Theme: Vicious
- Icon Theme: Carpentian-Gnome
- Window Style: Windows 9x inspired
