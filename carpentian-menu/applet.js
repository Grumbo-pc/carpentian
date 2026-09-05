const Applet = imports.ui.applet;
const Main = imports.ui.main;
const PopupMenu = imports.ui.popupMenu;
const Util = imports.misc.util;
const St = imports.gi.St;
const Clutter = imports.gi.Clutter;
const Gio = imports.gi.Gio;

class CarpentianMenu extends Applet.TextIconApplet {
    constructor(orientation, panel_height, instance_id) {
        super(orientation, panel_height, instance_id);

        this.setAllowedLayout(Applet.AllowedLayout.BOTH);
        this.set_applet_tooltip("Carpentian");
        this.set_applet_icon_name("carpentian-menu");

        this.menuManager = new PopupMenu.PopupMenuManager(this);
        this.menu = new Applet.AppletPopupMenu(this, orientation);
        this.menuManager.addMenu(this.menu);

        this.menu.connect("open-state-changed", (menu, open) => {
            if (open) this._refresh();
        });
    }

    _refresh() {
        this.menu.removeAll();

        let apps = this._getApps();

        // Search
        let searchItem = new PopupMenu.PopupBaseMenuItem({ reactive: false });
        let searchBox = new St.BoxLayout({ style: "background-color: #ffffff; border: 2px inset #808080; border-radius: 0; padding: 6px 10px;" });
        searchBox.add_actor(new St.Icon({ icon_name: "edit-find", icon_size: 18, style: "color: #808080; margin-right: 8px;" }));
        this._searchEntry = new St.Entry({ hint_text: "Search...", style: "background-color: transparent; border: none; color: #000000; font-size: 14px; min-width: 300px;" });
        searchBox.add_actor(this._searchEntry);
        searchItem.addActor(searchBox);
        this.menu.addMenuItem(searchItem);

        this._searchEntry.clutter_text.connect("text-changed", () => {
            let filter = this._searchEntry.get_text().toLowerCase();
            this._showApps(apps, filter);
        });

        // App container
        this._appContainer = new PopupMenu.PopupBaseMenuItem({ reactive: false });
        this._gridBox = new St.BoxLayout({ vertical: true, x_fill: true, y_fill: true });
        this._appContainer.addActor(this._gridBox);
        this.menu.addMenuItem(this._appContainer);

        this._showApps(apps, "");

        // System
        this.menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());

        let sysItems = [
            ["Lock Screen", "system-lock-screen", "light-locker-command -l"],
            ["Log Out", "system-log-out", "cinnamon-session-quit --logout --no-prompt"],
            ["Shut Down", "system-shutdown", "cinnamon-session-quit --power-off"]
        ];
        for (let i = 0; i < sysItems.length; i++) {
            let item = new PopupMenu.PopupIconMenuItem(sysItems[i][0], sysItems[i][1], St.IconType.FULLCOLOR);
            let cmd = sysItems[i][2];
            item.connect("activate", () => { Util.spawnCommandLine(cmd); this.menu.close(); });
            this.menu.addMenuItem(item);
        }
    }

    _showApps(apps, filter) {
        this._gridBox.destroy_all_children();

        let filtered = apps;
        if (filter.length > 0) {
            filtered = apps.filter(a => a.name.toLowerCase().indexOf(filter) !== -1);
        }

        let COLS = 8;
        let COL_W = 110;
        let ICON_SIZE = 48;
        let row = new St.BoxLayout({ spacing: 4 });
        this._gridBox.add_actor(row);

        for (let i = 0; i < filtered.length; i++) {
            if (i > 0 && i % COLS === 0) {
                row = new St.BoxLayout({ spacing: 4 });
                this._gridBox.add_actor(row);
            }

            let app = filtered[i];
            let item = new PopupMenu.PopupBaseMenuItem({ reactive: true });
            item.actor.set_width(COL_W);
            let inner = new St.BoxLayout({ vertical: true, x_align: Clutter.ActorAlign.CENTER });
            inner.add_actor(new St.Icon({ icon_name: app.icon, icon_size: ICON_SIZE, icon_type: St.IconType.FULLCOLOR }));
            let lbl = new St.Label({ text: app.name, style: "font-size: 11px; text-align: center; padding-top: 4px;" });
            lbl.clutter_text.set_line_wrap(true);
            lbl.set_width(COL_W - 8);
            inner.add_actor(lbl);
            item.addActor(inner);
            let cmd = app.exec;
            item.connect("activate", () => { Util.spawnCommandLine(cmd); this.menu.close(); });
            row.add_actor(item.actor);
        }

        if (filtered.length === 0) {
            this._gridBox.add_actor(new St.Label({ text: "(no applications found)", style: "padding: 20px;" }));
        }
    }

    _getApps() {
        let results = [];
        let seen = {};

        try {
            let allInfo = Gio.AppInfo.get_all();
            for (let i = 0; i < allInfo.length; i++) {
                let ai = allInfo[i];
                if (!ai.should_show()) continue;
                let name = ai.get_display_name();
                if (!name || name.length === 0) continue;
                if (seen[name]) continue;
                seen[name] = true;

                let iconName = "application-x-executable";
                try {
                    let icon = ai.get_icon();
                    if (icon && icon.get_names) {
                        let names = icon.get_names();
                        if (names && names.length > 0) iconName = names[0];
                    }
                } catch (e) {}

                let exec = "";
                try { exec = ai.get_executable(); } catch (e) {}

                results.push({ name: name, icon: iconName, exec: exec });
            }
        } catch (e) {
            global.logError("CarpentianMenu: " + e);
        }

        results.sort((a, b) => a.name.localeCompare(b.name));
        return results;
    }

    on_applet_clicked(event) {
        this.menu.toggle();
    }
}

function main(metadata, orientation, panel_height, instance_id) {
    return new CarpentianMenu(orientation, panel_height, instance_id);
}
