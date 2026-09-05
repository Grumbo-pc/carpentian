#!/bin/bash
set -ex

MENU=/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org

echo "=== Step 1: Create settings-override.json ==="
cat > "$MENU/settings-override.json" << 'OVERRIDE'
{
    "menu-custom": {
        "value": true
    },
    "menu-icon": {
        "value": "carpentian-menu"
    },
    "menu-icon-size": {
        "value": 32
    },
    "menu-label": {
        "value": "Carpentian"
    },
    "application-icon-size": {
        "value": 32
    },
    "category-icon-size": {
        "value": 22
    },
    "fav-icon-size": {
        "value": 32
    },
    "show-recents": {
        "value": false
    },
    "show-places": {
        "value": true
    },
    "favbox-show": {
        "value": true
    },
    "enable-animation": {
        "value": false
    },
    "show-category-icons": {
        "value": true
    },
    "show-application-icons": {
        "value": true
    }
}
OVERRIDE

echo "=== Step 2: Create Win9x stylesheet for the menu ==="
cat > "$MENU/stylesheet.css" << 'CSS'
/* Carpentian Win9x Menu Overrides */

/* The popup menu background */
.popup-menu-content .popup-menu {
    background-color: #c0c0c0;
    border: 3px outset #dfdfdf;
    border-radius: 0;
    padding: 0;
}

/* Search box */
.popup-menu-content .menu-search-box {
    background-color: #dfdfdf;
    border: none;
    padding: 4px;
}

.popup-menu-content .menu-search-box .st-entry {
    background-color: #ffffff;
    border: 2px inset #808080;
    border-radius: 0;
    color: #000000;
    padding: 4px 8px;
    font-size: 13px;
}

/* Categories sidebar */
.popup-menu-content .menu-applications-outer {
    background-color: #dfdfdf;
}

.popup-menu-content .menu-applications-outer .menu-categories-box {
    background-color: #000080;
    border: none;
    border-right: 3px outset #808080;
    padding: 0;
    spacing: 0;
}

/* Category buttons */
.popup-menu-content .menu-category-button {
    background-color: transparent;
    color: #ffffff;
    border: none;
    border-radius: 0;
    padding: 4px 12px;
    font-size: 13px;
    font-weight: bold;
    min-height: 32px;
}

.popup-menu-content .menu-category-button:hover {
    background-color: #1084d0;
}

.popup-menu-content .menu-category-button:checked {
    background-color: #1084d0;
    color: #ffffff;
}

.popup-menu-content .menu-category-button-label {
    color: #ffffff;
    font-size: 13px;
    font-weight: bold;
}

/* Application list */
.popup-menu-content .menu-applications-inner {
    background-color: #dfdfdf;
}

.popup-menu-content .menu-application-button {
    background-color: transparent;
    border: 1px solid transparent;
    border-radius: 0;
    padding: 2px 4px;
}

.popup-menu-content .menu-application-button:hover {
    background-color: #000080;
    border: 1px solid #1084d0;
}

.popup-menu-content .menu-application-button-label {
    color: #000000;
    font-size: 12px;
}

.popup-menu-content .menu-application-button:hover .menu-application-button-label {
    color: #ffffff;
}

/* Favorites sidebar (left pane) */
.popup-menu-content .menu-favbox {
    background-color: #c0c0c0;
    border-right: 2px outset #dfdfdf;
    padding: 4px;
}

.popup-menu-content .menu-favorites-button {
    background-color: transparent;
    border: 1px solid transparent;
    border-radius: 0;
    padding: 4px;
}

.popup-menu-content .menu-favorites-button:hover {
    background-color: #000080;
}

/* System buttons (shutdown, logout, etc) */
.popup-menu-content .menu-system-buttons {
    background-color: #c0c0c0;
    border-top: 2px outset #dfdfdf;
    padding: 4px;
    spacing: 4px;
}

.popup-menu-content .menu-system-button {
    background-color: #c0c0c0;
    color: #000000;
    border: 2px outset #dfdfdf;
    border-radius: 0;
    padding: 4px 8px;
}

.popup-menu-content .menu-system-button:hover {
    background-color: #000080;
    color: #ffffff;
}
CSS

echo "=== Step 3: Verify ==="
cat "$MENU/settings-override.json" | head -5
echo "---"
cat "$MENU/stylesheet.css" | head -5
echo "---"
ls "$MENU/"
