#!/usr/bin/env python3
path = "/root/carpentian-build/chroot/usr/bin/neofetch"
src = open(path).read()

target = "    # Calculate size of ascii file in line length / line count.\n"
assert target in src, "anchor not found"
idx = src.index(target)
block = src[idx:idx+400]
assert "line=${line//" in block

old_line = "        line=${line//\xf0\x9f\r// }"
# just find the numeric-padding loop line with the black-square skip
needle = "((++lines,${#line}>ascii_len))"
assert needle in src
# insert a strip of ANSI SGR sequences right before the count line
count_idx = src.index(needle)
insert = "        line=$(printf %s \"$line\" | sed 's/\\x1b\\[[0-9;]*m//g')\n"
if "sed 's/\\x1b" not in src:
    src = src[:count_idx] + insert + src[count_idx:]

open(path, "w").write(src)
print("patched OK")
import sys
for i, ln in enumerate(src.split("\n"), 1):
    if "Calculate size of ascii" in ln:
        for j in range(i, i+6):
            print(repr(src.split("\n")[j]))
        break