#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

echo "=== Applet base classes ==="
grep -n "TextIconApplet\|AllowedLayout\|AppletPopupMenu\|PopupResizeHandler" "$CHROOT/usr/share/cinnamon/js/ui/applet.js" | head -10

echo "=== How Cinnamon gets app list ==="
grep -rn "CMenu\|getTree\|TreeSystem\|AppSystem" "$CHROOT/usr/share/cinnamon/js/ui/" 2>/dev/null | grep -v ".pyc" | head -20

echo "=== existing Cinnamenu imports ==="
head -25 "$CHROOT/usr/share/cinnamon/applets/Cinnamenu@json/applet.js"
