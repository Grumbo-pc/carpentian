#!/bin/bash
set -ex
CHROOT=/root/carpentian-build/chroot

echo "=== Check AppletSettings path ==="
grep -n "getConfig\|config_paths\|Spices\|spices\|\.cinnamon" /usr/share/cinnamon/js/ui/appletManager.js 2>/dev/null | head -15

echo "=== Check what 10_cinnamon.gschema.override has ==="
cat /usr/share/glib-2.0/schemas/10_cinnamon.gschema.override

echo "=== Check /etc/skel current state ==="
find /etc/skel -type f 2>/dev/null || echo "(empty)"
