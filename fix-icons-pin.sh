#!/bin/bash
set -e

# Update pinned-apps to include spotify
chroot /root/carpentian-build/chroot /bin/bash -c '
python3 << PYEOF
import json
p = "/usr/share/cinnamon/applets/grouped-window-list@cinnamon.org/settings-schema.json"
with open(p) as f:
    d = json.load(f)
print("Before:", d["pinned-apps"]["default"])
d["pinned-apps"]["default"] = [
    "nemo.desktop",
    "firefox.desktop",
    "spotify.desktop",
    "code.desktop",
    "org.gnome.Terminal.desktop"
]
print("After:", d["pinned-apps"]["default"])
with open(p, "w") as f:
    json.dump(d, f, indent=2)
print("Pinned apps updated")
PYEOF
'

# Also add to dconf for the user
chroot /root/carpentian-build/chroot /bin/bash -c '
mkdir -p /etc/dconf/db/local.d
cat >> /etc/dconf/db/local.d/01-carpentian << EOF

[org/cinnamon/applets/grouped-window-list@cinnamon.org]
pinned-apps=["nemo.desktop", "firefox.desktop", "spotify.desktop", "code.desktop", "org.gnome.Terminal.desktop"]
EOF
dconf update
echo "dconf updated"
'

echo "Done pinning apps"
