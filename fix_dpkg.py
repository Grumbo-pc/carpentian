import re

path = "/var/lib/dpkg/status"
with open(path) as f:
    content = f.read()

blocks = content.split("\n\n")
new_blocks = []
changed = False
for b in blocks:
    if b.startswith("Package: memtest86+"):
        b = re.sub(r"^Status: .*$", "Status: deinstall ok config-files", b, flags=re.M)
        changed = True
    new_blocks.append(b)

if changed:
    with open(path, "w") as f:
        f.write("\n\n".join(new_blocks))
    print("Fixed memtest86+ status")
else:
    print("memtest86+ not found in status")