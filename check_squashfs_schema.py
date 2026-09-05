#!/usr/bin/env python3
import json, subprocess
data = subprocess.check_output([
    "unsquashfs", "-cat",
    "/root/carpentian-build/image/casper/filesystem.squashfs",
    "usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json"
], stderr=subprocess.DEVNULL)
d = json.loads(data)
print("menu-custom:", d["menu-custom"]["default"])
print("menu-icon:", d["menu-icon"]["default"])
print("menu-label:", d["menu-label"]["default"])
print("show-recents:", d.get("show-recents", {}).get("default", "NOT FOUND"))
print("enable-animation:", d.get("enable-animation", {}).get("default", "NOT FOUND"))
