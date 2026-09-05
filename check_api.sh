#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

echo "=== Applet base classes ==="
grep -n "TextIconApplet\|AllowedLayout\|AppletPopupMenu\|PopupResizeHandler" "$CHROOT/usr/share/cinnamon/js/ui/applet.js" | head -10

echo "=== CMenu API ==="
grep -n "getTree\|TreeSystem\|loadTree\|CMenu\|AppSystem" "$CHROOT/usr/share/cinnamon/js/ui/appFavorites.js" 2>/dev/null | head -10
grep -n "CMenu\|TreeSystem\|loadTree\|getTree" "$CHROOT/usr/share/cinnamon/js/ui/cinnamonDBus.js" 2>/dev/null | head -5

echo "=== How existing menu loads apps ==="
grep -n "CMenu\|cmenu\|getTree\|TreeSystem\|AppSystem\|get_all\|getFlattened" "$CHROOT/usr/share/cinnamon/applets/menu@cinnamon.org/applet.js" 2>/dev/null | head -20
