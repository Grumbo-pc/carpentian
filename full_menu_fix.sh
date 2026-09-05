#!/bin/bash
set -ex

# Approach: reinstall cinnamon-common to get clean files, then modify them via chroot
CHROOT=/root/carpentian-build/chroot

echo "=== Reinstall to get clean files ==="
chroot "$CHROOT" apt-get install --reinstall cinnamon-common -y 2>&1 | tail -3

echo "=== Verify files exist ==="
ls "$CHROOT/usr/share/cinnamon/applets/menu@cinnamon.org/" 2>&1

echo "=== Modify settings-schema.json via chroot ==="
chroot "$CHROOT" /bin/bash << 'PYFIX'
python3 -c "
import json
with open('/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json', 'r') as f:
    schema = json.load(f)
schema['menu-custom']['default'] = True
schema['menu-icon']['default'] = 'carpentian-menu'
schema['menu-label']['default'] = 'Carpentian'
schema['menu-icon-size']['default'] = 32
schema['application-icon-size']['default'] = 32
schema['category-icon-size']['default'] = 22
schema['fav-icon-size']['default'] = 32
schema['show-recents']['default'] = False
schema['enable-animation']['default'] = False
with open('/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json', 'w') as f:
    json.dump(schema, f, indent=4)
print('settings-schema.json updated via chroot')
"
PYFIX

echo "=== Create stylesheet.css via chroot ==="
chroot "$CHROOT" /bin/bash << 'CSSFILE'
cat > /usr/share/cinnamon/applets/menu@cinnamon.org/stylesheet.css << 'CSSEOF'
/* Carpentian Win9x Menu */
.popup-menu-content .popup-menu { background-color: #c0c0c0; border: 3px outset #dfdfdf; border-radius: 0; padding: 0; }
.popup-menu-content .menu-search-box { background-color: #dfdfdf; border: none; padding: 4px; }
.popup-menu-content .menu-search-box .st-entry { background-color: #ffffff; border: 2px inset #808080; border-radius: 0; color: #000000; padding: 4px 8px; font-size: 13px; }
.popup-menu-content .menu-applications-outer .menu-categories-box { background-color: #000080; border: none; border-right: 3px outset #808080; padding: 0; spacing: 0; }
.popup-menu-content .menu-category-button { background-color: transparent; color: #ffffff; border: none; border-radius: 0; padding: 4px 12px; font-size: 13px; font-weight: bold; min-height: 32px; }
.popup-menu-content .menu-category-button:hover { background-color: #1084d0; }
.popup-menu-content .menu-category-button:checked { background-color: #1084d0; color: #ffffff; }
.popup-menu-content .menu-category-button-label { color: #ffffff; font-size: 13px; font-weight: bold; }
.popup-menu-content .menu-applications-inner { background-color: #dfdfdf; }
.popup-menu-content .menu-application-button { background-color: transparent; border: 1px solid transparent; border-radius: 0; padding: 2px 4px; }
.popup-menu-content .menu-application-button:hover { background-color: #000080; border: 1px solid #1084d0; }
.popup-menu-content .menu-application-button-label { color: #000000; font-size: 12px; }
.popup-menu-content .menu-application-button:hover .menu-application-button-label { color: #ffffff; }
.popup-menu-content .menu-favbox { background-color: #c0c0c0; border-right: 2px outset #dfdfdf; padding: 4px; }
.popup-menu-content .menu-favorites-button { background-color: transparent; border: 1px solid transparent; border-radius: 0; padding: 4px; }
.popup-menu-content .menu-favorites-button:hover { background-color: #000080; }
.popup-menu-content .menu-system-buttons { background-color: #c0c0c0; border-top: 2px outset #dfdfdf; padding: 4px; spacing: 4px; }
.popup-menu-content .menu-system-button { background-color: #c0c0c0; color: #000000; border: 2px outset #dfdfdf; border-radius: 0; padding: 4px 8px; }
.popup-menu-content .menu-system-button:hover { background-color: #000080; color: #ffffff; }
CSSEOF
echo "stylesheet.css created via chroot"
CSSFILE

echo "=== Create settings-override.json via chroot ==="
chroot "$CHROOT" /bin/bash << 'OVFILE'
cat > /usr/share/cinnamon/applets/menu@cinnamon.org/settings-override.json << 'OVEOF'
{
    "menu-custom": {"value": true},
    "menu-icon": {"value": "carpentian-menu"},
    "menu-icon-size": {"value": 32},
    "menu-label": {"value": "Carpentian"},
    "application-icon-size": {"value": 32},
    "category-icon-size": {"value": 22},
    "fav-icon-size": {"value": 32},
    "show-recents": {"value": false},
    "enable-animation": {"value": false},
    "favbox-show": {"value": true},
    "show-places": {"value": true}
}
OVEOF
echo "settings-override.json created via chroot"
OVFILE

echo "=== Verify ==="
ls -la "$CHROOT/usr/share/cinnamon/applets/menu@cinnamon.org/"
