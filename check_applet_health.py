#!/usr/bin/env python3
import json
path = "/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json"
try:
    with open(path) as f:
        d = json.load(f)
    print("JSON valid")
    print("menu-custom default:", d["menu-custom"]["default"])
    print("menu-icon default:", d["menu-icon"]["default"])
except Exception as e:
    print("ERROR:", e)

# Check if applet.js was corrupted by the reinstall
applet = "/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/applet.js"
with open(applet) as f:
    content = f.read()
print("applet.js length:", len(content))
print("Has _initApplet:", "_initApplet" in content or "Applet.TextIconApplet" in content)
print("Has Carpentian inject:", "Carpentian: force" in content)
