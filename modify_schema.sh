#!/bin/bash
set -ex
MENU_DIR=/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org

echo "=== Modify settings-schema.json defaults ==="
python3 << 'PYFIX'
import json

with open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json", "r") as f:
    schema = json.load(f)

schema["menu-custom"]["default"] = True
schema["menu-icon"]["default"] = "carpentian-menu"
schema["menu-label"]["default"] = "Carpentian"
schema["menu-icon-size"]["default"] = 32
schema["application-icon-size"]["default"] = 32
schema["category-icon-size"]["default"] = 22
schema["fav-icon-size"]["default"] = 32
schema["show-recents"]["default"] = False
schema["enable-animation"]["default"] = False

with open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json", "w") as f:
    json.dump(schema, f, indent=4)
print("Done")
PYFIX

echo "=== Verify ==="
ls -la "$MENU_DIR/"
