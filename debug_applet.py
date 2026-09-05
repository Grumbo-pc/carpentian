#!/usr/bin/env python3
import json

path = "/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/settings-schema.json"
with open(path) as f:
    d = json.load(f)

for k, v in d.items():
    if k == "layout":
        continue
    if "type" not in v:
        print(f"MISSING type in key: {k}")

print("Schema OK, keys:", len([k for k in d if k != "layout"]))

# Now check what the applet.js actually reads
# Look for getValue calls to understand what settings it expects
applet = "/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/applet.js"
with open(applet) as f:
    js = f.read()

import re
gets = re.findall(r'getValue\("([^"]+)"\)', js)
print("\nSettings used by applet.js:")
for g in sorted(set(gets)):
    if g in d:
        print(f"  {g}: default={d[g].get('default', 'N/A')}")
    else:
        print(f"  {g}: NOT IN SCHEMA!")
