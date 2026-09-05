#!/bin/bash
echo "=== TreeSystem in Cinnamon JS ==="
grep -r "TreeSystem" /usr/share/cinnamon/js/ 2>/dev/null | head -5

echo "=== CMenu module ==="
python3 -c "
import gi
gi.require_version('CMenu', '3.0')
from gi.repository import CMenu
print('TreeSystem' in dir(CMenu))
print('TreeItemType' in dir(CMenu))
print('TreeItemType.ENTRY' if hasattr(CMenu, 'TreeItemType') else 'no TreeItemType')
" 2>&1

echo "=== Cinnamenu how it uses CMenu ==="
grep -n "TreeSystem\|get_root\|get_entry\|get_app_info\|CMenu.Tree" /usr/share/cinnamon/applets/Cinnamenu@json/applet.js 2>/dev/null | head -10

echo "=== AppSystem fallback check ==="
grep -n "AppSystem" /usr/share/cinnamon/js/ui/appFavorites.js 2>/dev/null | head -5
