#!/usr/bin/env python3
path = "/root/carpentian-build/chroot/usr/bin/neofetch"
lines = open(path).read().split("\n")

out = []
for i, ln in enumerate(lines):
    if "printf %s" in ln and "sed " in ln:
        ln = ln.strip()
        ln = "        " + ln
    if ln.lstrip().startswith("((++lines,${#line}>ascii_len))"):
        ln = "        " + ln.lstrip()
    out.append(ln)

open(path, "w").write("\n".join(out))
print("done")
for i in range(3884, 3894):
    print(i, repr(out[i]))