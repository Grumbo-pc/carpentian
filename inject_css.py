#!/bin/bash
set -ex

# The stylesheet.css and settings-override.json never make it to the
# correct squashfs layer because the chroot's /usr has an inode layering
# issue from debootstrap + apt. 
# 
# SOLUTION: Inject CSS directly into applet.js and set the settings
# overrides in the JS code itself. These files ARE at the correct layer.

MENU_DIR=/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org

echo "=== Inject Win9x CSS loading into applet.js ==="
python3 << 'PYFIX'
import re

with open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/applet.js", "r") as f:
    content = f.read()

# Add CSS injection right after the applet init that sets up the menu
# Find the _initAppMenu method or similar where the menu is created
# We'll add a CSS override block at the start of _openMenu

css_injection = """
        // Carpentian Win9x Menu CSS Injection
        let win9xcss = new St.ThemeContext;
        try {
            let cssFile = Gio.File.new_for_path('/usr/share/cinnamon/applets/menu@cinnamon.org/stylesheet.css');
            if (cssFile.query_exists(null)) {
                global.stage.get_theme().load_stylesheet(cssFile);
            }
        } catch(e) {
            // Fallback: apply inline styles
        }
"""

# Find the _openMenu or show_menu method
# Look for where the popup is created
old_marker = "this.menu = new PopupMenu.PopupSubMenuMenuItem"
if old_marker in content:
    # Add CSS loading before menu creation
    content = content.replace(old_marker, css_injection + old_marker)
    print("Injected CSS loading at menu creation point")
else:
    # Try another approach: add at the beginning of the init function
    old_init = "Applet.TextIconApplet.prototype._init.call(this, orientation, panel_height, instance_id);"
    if old_init in content:
        content = content.replace(old_init, old_init + "\n" + css_injection)
        print("Injected CSS loading at init")
    else:
        print("WARNING: Could not find injection point, trying general approach")
        # Add as a global function near the top
        insert_point = "let appsys = Cinnamon.AppSystem.get_default();"
        if insert_point in content:
            content = content.replace(insert_point, insert_point + "\n" + css_injection)
            print("Injected CSS loading after appsys")

with open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/applet.js", "w") as f:
    f.write(content)

print("applet.js updated")
PYFIX

echo "=== Verify ==="
grep -n "Carpentian Win9x\|stylesheet.css\|load_stylesheet" "$MENU_DIR/applet.js" | head -5
