#!/usr/bin/env python3
import re

applet = "/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/applet.js"
with open(applet) as f:
    js = f.read()

# Find all settings patterns
patterns = [
    r'getValue\("([^"]+)"\)',
    r'settings\.getValue\("([^"]+)"\)',
    r'bind\("([^"]+)"',
]
for p in patterns:
    matches = re.findall(p, js)
    if matches:
        print(f"Pattern: {p}")
        for m in sorted(set(matches)):
            print(f"  {m}")
        print()
