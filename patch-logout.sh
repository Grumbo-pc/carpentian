#!/bin/bash
set -e

python3 << 'PYEOF'
with open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3/applet.js", "r") as f:
    content = f.read()

old = """            powerBtn.connect('clicked', () => {
                this._destroyModal();
                Util.spawnCommandLine('cinnamon-session-quit --power-off');
            });
            searchBox.add_actor(powerBtn);"""

new = """            powerBtn.connect('clicked', () => {
                this._destroyModal();
                Util.spawnCommandLine('cinnamon-session-quit --power-off');
            });

            let logoutBtn = new St.Button({
                style: 'padding: 6px 10px; border-radius: 6px; background: rgba(255, 255, 255, 0.08); border: 1px solid rgba(255, 255, 255, 0.15); margin-left: 4px;'
            });
            let logoutIcon = new St.Icon({
                icon_name: 'system-log-out-symbolic',
                icon_size: 18,
                style: 'color: rgba(255, 255, 255, 0.8);'
            });
            logoutBtn.add_actor(logoutIcon);
            logoutBtn.connect('enter-event', () => {
                logoutBtn.set_style('padding: 6px 10px; border-radius: 6px; background: rgba(255, 255, 255, 0.18); border: 1px solid rgba(255, 255, 255, 0.3); margin-left: 4px;');
            });
            logoutBtn.connect('leave-event', () => {
                logoutBtn.set_style('padding: 6px 10px; border-radius: 6px; background: rgba(255, 255, 255, 0.08); border: 1px solid rgba(255, 255, 255, 0.15); margin-left: 4px;');
            });
            logoutBtn.connect('clicked', () => {
                this._destroyModal();
                Util.spawnCommandLine('cinnamon-session-quit --logout');
            });
            searchBox.add_actor(logoutBtn);"""

if old in content:
    content = content.replace(old, new)
    with open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3/applet.js", "w") as f:
        f.write(content)
    print("Patched successfully")
else:
    print("Pattern not found!")
PYEOF
