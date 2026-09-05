#!/usr/bin/env python3
import sys

MENU = "/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/applet.js"

with open(MENU, "r") as f:
    content = f.read()

# 1. Inject Win9x settings overrides after settings init
old_settings = 'this.settings = new Settings.AppletSettings(this, "menu@cinnamon.org", instance_id);'
new_settings = """this.settings = new Settings.AppletSettings(this, "menu@cinnamon.org", instance_id);

        // Carpentian: force Win9x defaults
        try {
            if (!this.settings.getValue("menu-custom")) this.settings.setValue("menu-custom", true);
            this.settings.setValue("menu-icon", "carpentian-menu");
            this.settings.setValue("menu-label", "Carpentian");
            this.settings.setValue("menu-icon-size", 32);
            this.settings.setValue("application-icon-size", 32);
            this.settings.setValue("category-icon-size", 22);
            this.settings.setValue("fav-icon-size", 32);
            this.settings.setValue("show-recents", false);
            this.settings.setValue("enable-animation", false);
        } catch(e) {}"""

if old_settings in content:
    content = content.replace(old_settings, new_settings)
    print("OK: Injected Win9x settings overrides")
else:
    print("FAIL: Could not find settings constructor")
    sys.exit(1)

# 2. Inject Win9x CSS after the popup menu container creation
# Find where the applicationsBox is created (the main menu body)
marker = "this._applicationsBox = new St.BoxLayout("
css_block = """
        // Carpentian Win9x menu styling
        try {
            let cssFile = Gio.File.new_for_path('/usr/share/cinnamon/applets/menu@cinnamon.org/stylesheet.css');
            if (cssFile.query_exists(null)) {
                let theme = St.ThemeContext.get_for_stage(global.stage);
                theme.get_theme().load_stylesheet(cssFile);
            }
        } catch(e) {}
        """

if marker in content:
    content = content.replace(marker, css_block + "        " + marker)
    print("OK: Injected CSS loading")
else:
    print("WARN: CSS marker not found, trying alt")
    alt = "this._applicationsBox = new"
    if alt in content:
        print("WARN: partial match found but skipping CSS injection")

with open(MENU, "w") as f:
    f.write(content)

print("Done!")
