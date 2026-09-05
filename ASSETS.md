# Assets

The final ISO depends on theme assets that are NOT tracked in this repository
because they come from a separate "carpentian theme" folder. Place them into the
chroot during **Stage 2 – Customize** (see BUILDING.md §4):

| Asset | Destination (in chroot) |
|-------|--------------------------|
| 5 desktop wallpapers + 1 lock screen | `/usr/share/backgrounds/carpentian/` |
| Boot splash | `/usr/share/plymouth/themes/carpentian/` + `/boot/grub/themes/carpentian/` |
| `Carpentian-Gnome` icons + `Carpentian-cursors` | `/usr/share/icons/` |
| `Carpentian-Win9x` GTK/Cinnamon theme | `/usr/share/themes/` |
| Vicious sounds | `/usr/share/sounds/` + `/usr/share/sounds/carpentian-sounds/` |
| neofetch art | `/usr/share/neofetch/ascii/Carpentian` |
| Carpentian menu logo | `/usr/share/icons/carpentian-menu.png` |

The Calamares installer branding in `config/calamares/branding/carpentian/`
already includes a tiny re-used logo/welcome image so the tree is self-contained,
but the full desktop theming above is required for the real look.
