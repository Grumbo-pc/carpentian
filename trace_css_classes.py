#!/usr/bin/env python3
import re

# Check what CSS classes the menu applet actually uses
applet = "/root/carpentian-build/chroot/usr/share/cinnamon/applets/menu@cinnamon.org/applet.js"
with open(applet) as f:
    js = f.read()

# Find all style_class = "..." and add_style_class_name / remove_style_class_name
classes = set()
for m in re.finditer(r'style_class\s*=\s*["\']([^"\']+)', js):
    classes.add(m.group(1))
for m in re.finditer(r'add_style_class_name\(["\']([^"\']+)', js):
    classes.add(m.group(1))
for m in re.finditer(r'add_style_class\(["\']([^"\']+)', js):
    classes.add(m.group(1))
for m in re.finditer(r'set_style_class\(["\']([^"\']+)', js):
    classes.add(m.group(1))

print("CSS classes used in applet.js:")
for c in sorted(classes):
    print(f"  .{c}")

# Also check what our cinnamon.css has
print("\nCSS selectors in Carpentian theme:")
css = "/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/cinnamon/cinnamon.css"
with open(css) as f:
    content = f.read()
for m in re.finditer(r'\.([\w-]+)\s*\{', content):
    name = m.group(1)
    if 'menu' in name.lower():
        print(f"  .{name}")

# Check default cinnamon.css
print("\nCSS selectors in default theme:")
css2 = "/root/carpentian-build/chroot/usr/share/cinnamon/theme/cinnamon.css"
with open(css2) as f:
    content2 = f.read()
for m in re.finditer(r'\.([\w-]+)\s*\{', content2):
    name = m.group(1)
    if 'menu' in name.lower():
        print(f"  .{name}")
