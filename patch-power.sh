#!/bin/bash
set -e

APPLET="/root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3/applet.js"

# Replace the searchBox section to include power buttons
python3 << 'PYEOF'
import re

with open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3/applet.js", "r") as f:
    content = f.read()

old = """            searchBox.add_actor(this.searchEntry);
            container.add_actor(searchBox);"""

new = """            searchBox.add_actor(this.searchEntry);

            let powerBox = new St.BoxLayout({
                style: 'spacing: 4px; padding: 0 8px;'
            });

            let powerButtons = [
                { icon: 'system-shutdown-symbolic', tooltip: _('Log Out'), cmd: 'innamon-session-logout --logout --no-prompt' },
                { icon: 'system-shutdown-symbolic', tooltip: _('Shut Down'), cmd: 'systemctl poweroff' },
                { icon: 'system-reboot-symbolic', tooltip: _('Restart'), cmd: 'systemctl reboot' }
            ];

            for (let pb of powerButtons) {
                let btn = new St.Button({
                    style: 'padding: 6px 10px; border-radius: 6px; background: rgba(255, 255, 255, 0.08); border: 1px solid rgba(255, 255, 255, 0.15);'
                });
                let icon = new St.Icon({
                    icon_name: pb.icon,
                    icon_size: 18,
                    style: 'color: rgba(255, 255, 255, 0.8);'
                });
                btn.add_actor(icon);
                btn._tooltipText = pb.tooltip;
                btn._cmd = pb.cmd;
                btn.connect('enter-event', () => {
                    btn.set_style('padding: 6px 10px; border-radius: 6px; background: rgba(255, 255, 255, 0.18); border: 1px solid rgba(255, 255, 255, 0.3);');
                });
                btn.connect('leave-event', () => {
                    btn.set_style('padding: 6px 10px; border-radius: 6px; background: rgba(255, 255, 255, 0.08); border: 1px solid rgba(255, 255, 255, 0.15);');
                });
                btn.connect('clicked', () => {
                    this._destroyModal();
                    Util.spawnCommandLine('bash -c ' + pb.cmd);
                });
                powerBox.add_actor(btn);
            }

            searchBox.add_actor(powerBox);
            container.add_actor(searchBox);"""

if old in content:
    content = content.replace(old, new)
    with open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3/applet.js", "w") as f:
        f.write(content)
    print("Patched successfully")
else:
    print("Pattern not found!")
    # Debug
    lines = content.split('\n')
    for i, line in enumerate(lines):
        if 'searchBox.add_actor' in line:
            print(f"  Line {i+1}: {line.strip()}")
PYEOF
