#!/usr/bin/env python3
import json
path = "/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json"
with open(path, "r") as f:
    d = json.load(f)
d["menu-custom"]["default"] = True
d["menu-icon"]["default"] = "carpentian-menu"
d["menu-label"]["default"] = "Carpentian"
d["menu-icon-size"]["default"] = 32
d["application-icon-size"]["default"] = 32
d["category-icon-size"]["default"] = 22
d["fav-icon-size"]["default"] = 32
d["show-recents"]["default"] = False
d["enable-animation"]["default"] = False
d["favbox-show"]["default"] = True
d["show-places"]["default"] = True
with open(path, "w") as f:
    json.dump(d, f, indent=4)
print("settings-schema.json updated")
