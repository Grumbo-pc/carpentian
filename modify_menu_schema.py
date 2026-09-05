#!/bin/bash
set -ex

# The chroot has a layering issue where manually-created files and
# apt-installed files end up in different squashfs layers.
# Fix: modify the EXISTING applet.js file directly instead of creating new files.

# Approach: modify settings-schema.json defaults in place
# This file IS at the correct usr/ layer

# Step 1: Modify settings-schema.json defaults
python3 << 'PYFIX'
import json

with open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json", "r") as f:
    schema = json.load(f)

# Change defaults for Win9x look
schema["menu-custom"]["default"] = True
schema["menu-icon"]["default"] = "carpentian-menu"
schema["menu-icon-size"]["default"] = 32
schema["menu-label"]["default"] = "Carpentian"
schema["application-icon-size"]["default"] = 32
schema["category-icon-size"]["default"] = 22
schema["fav-icon-size"]["default"] = 32
schema["show-recents"]["default"] = False
schema["show-places"]["default"] = True
schema["favbox-show"]["default"] = True
schema["enable-animation"]["default"] = False

with open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json", "w") as f:
    json.dump(schema, f, indent=4)

print("settings-schema.json updated")
PYFIX

echo "=== Verify ==="
grep -A2 '"menu-custom"' /root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json
grep -A2 '"menu-icon"' /root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json | head -5
grep -A2 '"menu-label"' /root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json | head -5
