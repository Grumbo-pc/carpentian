#!/bin/bash
set -e

APPLET_DIR="/root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3"

# Customize settings-schema defaults for Win9x theme
cat > "$APPLET_DIR/settings-schema.json" << 'SCHEMA'
{
    "navigation": {
        "type": "header",
        "description": "Navigation Settings"
    },
    "navigationMode": {
        "type": "combobox",
        "default": "scroll-vertical",
        "description": "Navigation mode",
        "options": {
            "Scroll Vertical": "scroll-vertical",
            "Button Navigation": "buttons",
            "Scroll Horizontal": "scroll-horizontal"
        }
    },
    "layout": {
        "type": "header",
        "description": "Layout Settings"
    },
    "columns": {
        "type": "spinbutton",
        "default": 8,
        "min": 2,
        "max": 12,
        "step": 1,
        "description": "Columns per page"
    },
    "rows": {
        "type": "spinbutton",
        "default": 5,
        "min": 2,
        "max": 8,
        "step": 1,
        "description": "Rows per page"
    },
    "iconSize": {
        "type": "spinbutton",
        "default": 48,
        "min": 32,
        "max": 128,
        "step": 8,
        "description": "Icon size (px)"
    },
    "padding": {
        "type": "spinbutton",
        "default": 12,
        "min": 4,
        "max": 48,
        "step": 2,
        "description": "Padding (px)"
    },
    "fontSize": {
        "type": "spinbutton",
        "default": 10,
        "min": 8,
        "max": 18,
        "step": 1,
        "description": "Label font size (pt)"
    },
    "features": {
        "type": "header",
        "description": "Features"
    },
    "enableSearch": {
        "type": "checkbox",
        "default": true,
        "description": "Enable search bar"
    },
    "autoFocusSearch": {
        "type": "checkbox",
        "default": true,
        "description": "Auto-focus search bar when opened",
        "dependency": "enableSearch"
    },
    "enableFavorites": {
        "type": "checkbox",
        "default": false,
        "description": "Enable favorites"
    },
    "favoriteApps": {
        "type": "generic",
        "default": []
    },
    "overlay-keybinding": {
        "type": "keybinding",
        "default": "<Super>a",
        "description": "Keyboard shortcut to toggle overlay"
    },
    "appearance": {
        "type": "header",
        "description": "Appearance Settings"
    },
    "bgColor": {
        "type": "colorchooser",
        "default": "rgb(0, 0, 0)",
        "description": "Background color"
    },
    "bgOpacity": {
        "type": "spinbutton",
        "default": 95,
        "min": 0,
        "max": 100,
        "step": 5,
        "units": "%",
        "description": "Background opacity"
    },
    "containerColor": {
        "type": "colorchooser",
        "default": "rgb(27, 27, 47)",
        "description": "Container color"
    },
    "containerOpacity": {
        "type": "spinbutton",
        "default": 95,
        "min": 0,
        "max": 100,
        "step": 5,
        "units": "%",
        "description": "Container opacity"
    },
    "boxColor": {
        "type": "colorchooser",
        "default": "rgb(45, 45, 68)",
        "description": "Box color"
    },
    "boxOpacity": {
        "type": "spinbutton",
        "default": 30,
        "min": 0,
        "max": 100,
        "step": 5,
        "units": "%",
        "description": "Box opacity"
    },
    "boxHoverColor": {
        "type": "colorchooser",
        "default": "rgb(0, 0, 128)",
        "description": "Box hover color"
    },
    "boxHoverOpacity": {
        "type": "spinbutton",
        "default": 60,
        "min": 0,
        "max": 100,
        "step": 5,
        "units": "%",
        "description": "Box hover opacity"
    },
    "animations": {
        "type": "header",
        "description": "Animation Settings"
    },
    "enableAnimations": {
        "type": "checkbox",
        "default": true,
        "description": "Enable animations"
    },
    "animationDuration": {
        "type": "spinbutton",
        "default": 300,
        "min": 100,
        "max": 1000,
        "step": 50,
        "units": "ms",
        "description": "Animation duration",
        "dependency": "enableAnimations"
    },
    "openAnimationType": {
        "type": "combobox",
        "default": "fade",
        "description": "Open animation",
        "options": {
            "Fade": "fade",
            "Scale": "scale",
            "Slide Up": "slide-up",
            "Zoom": "zoom"
        },
        "dependency": "enableAnimations"
    },
    "closeAnimationType": {
        "type": "combobox",
        "default": "fade",
        "description": "Close animation",
        "options": {
            "Fade": "fade",
            "Scale": "scale",
            "Slide Down": "slide-down",
            "Zoom": "zoom"
        },
        "dependency": "enableAnimations"
    },
    "pageAnimationType": {
        "type": "combobox",
        "default": "crossfade",
        "description": "Button navigation page animation",
        "options": {
            "Fade": "fade",
            "Slide": "slide",
            "Crossfade": "crossfade"
        },
        "dependency": "enableAnimations"
    }
}
SCHEMA

# Update panel setup script to use app-drawer@mostlynick3
PANEL_SCRIPT="/root/carpentian-build/chroot/usr/share/customscripts/carpentian-panel-setup.sh"
if [ -f "$PANEL_SCRIPT" ]; then
    sed -i 's/carpentian-menu@carpentian/app-drawer@mostlynick3/g' "$PANEL_SCRIPT"
    echo "Updated panel setup script"
fi

# Update dconf database
DCONF_DB="/root/carpentian-build/chroot/etc/dconf/db/local.d/01-carpentian"
if [ -f "$DCONF_DB" ]; then
    sed -i 's/carpentian-menu@carpentian/app-drawer@mostlynick3/g' "$DCONF_DB"
    echo "Updated dconf database"
fi

# Update gschema override
GSCHEMA="/root/carpentian-build/chroot/usr/share/glib-2.0/schemas/11_cinnamon.gschema.override"
if [ -f "$GSCHEMA" ]; then
    sed -i 's/carpentian-menu@carpentian/app-drawer@mostlynick3/g' "$GSCHEMA"
    echo "Updated gschema override"
fi

# Compile gschema
chroot /root/carpentian-build/chroot glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>&1 || echo "gschema compile warning"

# Update dconf database
chroot /root/carpentian-build/chroot dconf update 2>&1 || echo "dconf update warning"

echo "=== DONE ==="
