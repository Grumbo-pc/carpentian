#!/bin/bash
set -ex

CHROOT=/root/carpentian-build/chroot

echo "=== 1. Modify settings-schema.json FROM WSL ==="
python3 << 'PYMOD'
import json
path = "/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json"
with open(path, "r") as f:
    d = json.load(f)
d["menu-custom"]["default"] = True
d["menu-icon"]["default"] = "carpentian-menu"
d["menu-label"]["default"] = "Carpentian"
d["menu-icon-size"]["default"] = 32
d["application-icon-size"]["default"] = 32
d["category-icon-size"]["default"] = 22
d["fav-icon-size"]["default"] = 32
d["show-recents"]["default"] = False
d["enable-animation"]["default"] = False
d["favbox-show"]["default"] = True
d["show-places"]["default"] = True
with open(path, "w") as f:
    json.dump(d, f, indent=4)
print("settings-schema.json updated from WSL")
PYMOD

echo "=== 2. Add Win9x menu styling to cinnamon.css ==="
python3 << 'CSSEOF'
path = "/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/cinnamon/cinnamon.css"
with open(path, "r") as f:
    css = f.read()

win9x = """

/* ===========================================================
 * Carpentian Win9x Menu Overrides
 * =========================================================== */

/* Menu popup background */
.menu {
    background-color: #c0c0c0;
    border: 3px outset #dfdfdf;
    border-radius: 0;
    color: #000000;
}

/* Favorites sidebar */
.menu-favorites-box {
    background-color: #c0c0c0;
    border-right: 2px outset #dfdfdf;
    border-radius: 0;
    padding: 4px;
}
.menu-favorites-button {
    padding: 6px;
    border-radius: 0;
    border: 1px solid transparent;
}
.menu-favorites-button:hover {
    background-color: #000080;
    color: #ffffff;
    border-radius: 0;
}

/* Categories sidebar */
.menu-categories-box {
    background-color: #000080;
    padding: 4px;
    border-right: 3px outset #808080;
}
.menu-category-button {
    padding: 6px 12px;
    color: #ffffff;
    border-radius: 0;
    border: 1px solid transparent;
    min-height: 28px;
}
.menu-category-button:hover {
    background-color: #1084d0;
    border-radius: 0;
}
.menu-category-button-selected {
    background-color: #1084d0;
    color: #ffffff;
    border-radius: 0;
    box-shadow: none;
}
.menu-category-button-label {
    color: #ffffff;
    font-size: 13px;
    font-weight: bold;
}
.menu-category-button-greyed {
    color: #808080;
    font-style: italic;
    border-radius: 0;
}

/* Applications list */
.menu-applications-outer-box {
    background-color: #dfdfdf;
    border-radius: 0;
    padding: 4px;
}
.menu-applications-inner-box {
    background-color: #dfdfdf;
    margin: 0;
}
.menu-application-button {
    padding: 4px 8px;
    border-radius: 0;
    border: 1px solid transparent;
}
.menu-application-button:hover {
    background-color: #000080;
    border-radius: 0;
    box-shadow: none;
}
.menu-application-button-label {
    color: #000000;
    font-size: 12px;
}
.menu-application-button:hover .menu-application-button-label {
    color: #ffffff;
}
.menu-application-button-selected {
    background-color: #000080;
    color: #ffffff;
    border-radius: 0;
    box-shadow: none;
}

/* Search box */
.menu-search-box {
    padding: 4px 8px;
}
#menu-search-entry {
    background-color: #ffffff;
    border: 2px inset #808080;
    border-radius: 0;
    color: #000000;
    padding: 4px 8px;
    font-size: 13px;
    width: 250px;
    box-shadow: none;
}
#menu-search-entry:focus {
    border: 2px inset #808080;
    background-color: #ffffff;
    color: #000000;
    box-shadow: none;
}

/* Menu title (Carpentian label) */
.menu-top-box {
    spacing: 8px;
}

/* Bottom description area */
.menu-selected-app-box {
    background-color: #c0c0c0;
    border-top: 2px outset #dfdfdf;
    padding: 4px 12px;
}
.menu-selected-app-title {
    color: #000000;
    font-weight: bold;
}
.menu-selected-app-description {
    color: #404040;
}

/* System buttons at bottom */
.menu-systembuttons-box {
    background-color: #c0c0c0;
    border-top: 2px outset #dfdfdf;
    padding: 4px;
}

/* Panel menu button (leftmost) */
.applet-menu-icon {
    padding: 0 4px;
}
"""

# Replace the existing empty .menu {} block and append our overrides
# First, try to replace the empty .menu {} block
if ".menu {\n}" in css:
    css = css.replace(".menu {\n}", ".menu {\n    background-color: #c0c0c0;\n    border: 3px outset #dfdfdf;\n    border-radius: 0;\n    color: #000000;\n}")

# Append the rest at the end
css += win9x

with open(path, "w") as f:
    f.write(css)
print("cinnamon.css updated with Win9x menu overrides")
CSSEOF

echo "=== 3. Verify ==="
echo "Schema defaults:"
python3 -c "import json; d=json.load(open('$CHROOT/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json')); print('  menu-custom:', d['menu-custom']['default']); print('  menu-icon:', d['menu-icon']['default']); print('  menu-label:', d['menu-label']['default'])"
echo "CSS has Win9x:"
grep -c "Carpentian Win9x" "$CHROOT/usr/share/cinnamon/theme/cinnamon.css"
