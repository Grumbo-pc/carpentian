#!/bin/bash
# deploy-installer.sh - Install + configure the Calamares installer into a built chroot.
# Usage: deploy-installer.sh <path-to-chroot>
# Requires: the Carpentian branding + Calamares configs in ../config/calamares
set -euo pipefail
ROOT="${1:?usage: deploy-installer.sh <chroot>}"
HERE=$(cd "$(dirname "$0")" && pwd)
CONF="$HERE/../config/calamares"
SRC=/usr/local/sbin

echo "[1/6] Install Calamares + settings"
chroot "$ROOT" bash -c "DEBIAN_FRONTEND=noninteractive apt-get install -y \
  calamares calamares-settings-ubuntu-common calamares-settings-ubuntu-unity"

echo "[2/6] Drop in Carpentian Calamares config"
rm -rf "$ROOT/etc/calamares"
cp -r "$CONF" "$ROOT/etc/calamares"

echo "[3/6] Install auto-launch script + desktop entries"
install -m755 "$HERE/carpentian-calamares.sh" "$ROOT$SRC/carpentian-calamares.sh"
cp "$HERE/carpentian-installer.desktop" "$ROOT/etc/xdg/autostart/carpentian-installer.desktop"

echo "[4/6] NOPASSWD sudo for live user (installer runs as root)"
echo "carpentian  ALL=(ALL) NOPASSWD: ALL" > "$ROOT/etc/sudoers.d/carpentian-live"
chmod 440 "$ROOT/etc/sudoers.d/carpentian-live"

echo "[5/6] DNS: enable systemd-resolved so Firefox works"
ln -sf /usr/lib/systemd/system/systemd-resolved.service "$ROOT/etc/systemd/system/multi-user.target.wants/systemd-resolved.service"
mkdir -p "$ROOT/etc/NetworkManager/conf.d"
echo -e "[main]\ndns=systemd-resolved" > "$ROOT/etc/NetworkManager/conf.d/dns.conf"
rm -f "$ROOT/etc/resolv.conf"
ln -sf /run/systemd/resolve/stub-resolv.conf "$ROOT/etc/resolv.conf"

echo "[6/6] Patch calamares-logs-helper to not fail on missing logs"
cat > "$ROOT/usr/bin/calamares-logs-helper" << 'HELPER'
#!/bin/sh
root=$1
install_dir=$root/var/log/installer
[ -d "$install_dir" ] || mkdir -p "$install_dir"
cp "$HOME/.cache/calamares/session.log" "$install_dir/debug" 2>/dev/null || true
cp /cdrom/.disk/info "$install_dir/media-info" 2>/dev/null || true
cp /var/log/casper.log "$install_dir/casper.log" 2>/dev/null || true
cp /var/log/syslog "$install_dir/syslog" 2>/dev/null || true
gzip --stdout "$root/var/lib/dpkg/status" > "$install_dir/initial-status.gz" 2>/dev/null || true
chmod -v 600 "$install_dir"/* 2>/dev/null || true
chmod -v 644 "$install_dir"/initial-status.gz 2>/dev/null || true
chmod -v 644 "$install_dir"/media-info 2>/dev/null || true
exit 0
HELPER
chmod +x "$ROOT/usr/bin/calamares-logs-helper"

echo "### Done. Installer deployed to chroot $ROOT"
