#!/usr/bin/env python3
"""Inject Carpentian Win9x defaults directly into applet.js.
Only modifies files that already exist in the correct squashfs layer."""

import sys

MENU = "/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/applet.js"

with open(MENU, "r") as f:
    content = f.read()

# 1. Find where settings are loaded and override defaults
# Look for the Settings.AppletSettings constructor
old_settings = "this.settings = new Settings.AppletSettings(this, metadata.uuid, instance_id);"
new_settings = """this.settings = new Settings.AppletSettings(this, metadata.uuid, instance_id);

        // Carpentian: force Win9x defaults
        try {
            if (!this.settings.getValue("menu-custom")) this.settings.setValue("menu-custom", true);
            if (this.settings.getValue("menu-icon") !== "carpentian-menu") this.settings.setValue("menu-icon", "carpentian-menu");
            if (this.settings.getValue("menu-label") !== "Carpentian") this.settings.setValue("menu-label", "Carpentian");
            if (this.settings.getValue("menu-icon-size") !== 32) this.settings.setValue("menu-icon-size", 32);
            if (this.settings.getValue("application-icon-size") !== 32) this.settings.setValue("application-icon-size", 32);
            if (this.settings.getValue("category-icon-size") !== 22) this.settings.setValue("category-icon-size", 22);
            if (this.settings.getValue("fav-icon-size") !== 32) this.settings.setValue("fav-icon-size", 32);
            if (this.settings.getValue("show-recents") !== false) this.settings.setValue("show-recents", false);
            if (this.settings.getValue("enable-animation") !== false) this.settings.setValue("enable-animation", false);
        } catch(e) {}"""

if old_settings in content:
    content = content.replace(old_settings, new_settings)
    print("OK: Injected Win9x settings overrides")
else:
    print("WARN: Could not find AppletSettings constructor, trying alternative")
    # Try alternate pattern
    alt = "this.settings = new Settings.AppletSettings(this, metadata.uuid, instance_id)"
    if alt in content:
        content = content.replace(alt, new_settings)
        print("OK: Injected via alternate pattern")
    else:
        print("FAIL: Could not find injection point for settings")
        sys.exit(1)

# 2. Find where the menu popup is styled and inject Win9x CSS
# Look for where the popupMenuBox or main menu container is created
# We'll add a style_class override
css_style_injection = """
        // Carpentian Win9x styling
        this.menu.actor.style_class = 'popup-menu carpentian-win9x-menu';
        try {
            let cssFile = Gio.File.new_for_path('/usr/share/cinnamon/applets/menu@cinnamon.org/stylesheet.css');
            if (cssFile.query_exists(null)) {
                let theme = St.ThemeContext.get_for_stage(global.stage);
                theme.get_theme().load_stylesheet(cssFile);
            }
        } catch(e) {}"""

# Find a good place to inject - after menu creation in the _init or _openMenu
# The menu is typically created in the init with this.menu = new ...
# Let's look for the pattern where the popup is first shown
markers = [
    "this._applicationsBox = new St.BoxLayout(",
    "this._categoriesBox = new St.BoxLayout(",
    "this._favoritesBox = new St.BoxLayout(",
]

injected = False
for marker in markers:
    if marker in content and not injected:
        # Find the enclosing function and add CSS loading
        content = content.replace(marker, css_style_injection + "\n        " + marker)
        injected = True
        print(f"OK: Injected CSS loading near '{marker[:40]}...'")

if not injected:
    print("WARN: Could not find CSS injection point (may not be critical)")

with open(MENU, "w") as f:
    f.write(content)

print("applet.js modified successfully")
