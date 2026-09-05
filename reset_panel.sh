#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

# === 1. Delete ALL cached Cinnamon configs so it rebuilds from dconf defaults ===
rm -rf "$CHROOT/home/carpentian/.cinnamon"
mkdir -p "$CHROOT/home/carpentian/.cinnamon/configs"

# === 2. Copy Cinnamenu config ===
mkdir -p "$CHROOT/home/carpentian/.cinnamon/configs/Cinnamenu@json"
cp /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/cinnamenu-config.json "$CHROOT/home/carpentian/.cinnamon/configs/Cinnamenu@json/0.json"
cp /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/cinnamenu-stylesheet.css "$CHROOT/home/carpentian/.cinnamon/configs/Cinnamenu@json/stylesheet.css"

# === 3. Fix ownership ===
chroot "$CHROOT" chown -R 1000:1000 /home/carpentian/.cinnamon/

# === 4. Verify dconf is correct ===
echo "=== dconf enabled-applets ==="
dconf read /org/cinnamon/enabled-applets 2>/dev/null
echo "=== dconf favorite-apps ==="
dconf read /org/cinnamon/favorite-apps 2>/dev/null

echo "=== DONE - all cached panel data cleared ==="
ls -la "$CHROOT/home/carpentian/.cinnamon/"
ls -la "$CHROOT/home/carpentian/.cinnamon/configs/Cinnamenu@json/"
