#!/bin/bash
set -e

python3 << 'PYEOF'
with open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3/applet.js", "r") as f:
    content = f.read()

old = """            powerBtn.connect('clicked', () => {
                this._destroyModal();
                Util.spawnCommandLine('cinnamon-session-quit --power-off');
            });

            let logoutBtn"""

new = """            powerBtn.connect('clicked', () => {
                this._destroyModal();
                Util.spawnCommandLine('cinnamon-session-quit --power-off');
            });
            searchBox.add_actor(powerBtn);

            let logoutBtn"""

if old in content:
    content = content.replace(old, new)
    with open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3/applet.js", "w") as f:
        f.write(content)
    print("Patched successfully")
else:
    print("Pattern not found!")
PYEOF
