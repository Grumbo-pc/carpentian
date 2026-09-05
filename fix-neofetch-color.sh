#!/bin/bash
python3 - <<'PYEOF'
import re
path = "/root/carpentian-build/chroot/usr/share/neofetch/ascii/Carpentian"
with open(path) as f:
    lines = f.readlines()

ESC = "\033[38;2;149;201;240m"
out = []
for ln in lines:
    ln = re.sub(r"\$\{c[0-9]\}", "", ln)
    ln = ln.replace("\n", "")
    if ln.strip():
        out.append(ESC + ln + "\n")
    else:
        out.append("\n")

with open(path, "w") as f:
    f.writelines(out)
print("written, lines:", len(out))
PYEOF

echo "=== escaped view (first 6 lines) ==="
head -6 /root/carpentian-build/chroot/usr/share/neofetch/ascii/Carpentian | cat -A | sed 's/\^\[/ESC[/g'
echo "=== leftover cN count (should be 0) ==="
grep -c '\${c[0-9]}' /root/carpentian-build/chroot/usr/share/neofetch/ascii/Carpentian || true