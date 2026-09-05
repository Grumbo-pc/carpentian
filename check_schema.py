#!/usr/bin/env python3
import json
f=open("/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json")
d=json.load(f)
print("menu-custom:", d["menu-custom"]["default"])
print("menu-icon:", d["menu-icon"]["default"])
print("menu-label:", d["menu-label"]["default"])
print("show-recents:", d.get("show-recents", {}).get("default", "NOT FOUND"))
