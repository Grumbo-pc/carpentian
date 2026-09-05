#!/usr/bin/env python3
import sys

CASPER = "/root/carpentian-build/chroot/usr/share/initramfs-tools/scripts/casper"

with open(CASPER, "r") as f:
    lines = f.readlines()

new_lines = [
    '    # Robust overlay loading: modprobe -> modprobe w/o blacklist -> insmod -> decompress+insmod\n',
    '    if ! modprobe ${MP_QUIET} -b overlay 2>/dev/null; then\n',
    '        echo "casper: modprobe -b overlay failed, trying without blacklist" >&2\n',
    '        if ! modprobe ${MP_QUIET} overlay 2>/dev/null; then\n',
    '            echo "casper: modprobe overlay failed, trying insmod" >&2\n',
    '            OVERLAY_FOUND=0\n',
    '            for kmodfile in /lib/modules/*/kernel/fs/overlayfs/overlay.ko* /usr/lib/modules/*/kernel/fs/overlayfs/overlay.ko*; do\n',
    '                if [ -f "$kmodfile" ]; then\n',
    '                    echo "casper: trying insmod $kmodfile" >&2\n',
    '                    if insmod "$kmodfile" 2>&1; then\n',
    '                        OVERLAY_FOUND=1\n',
    '                        break\n',
    '                    fi\n',
    '                fi\n',
    '            done\n',
    '            if [ "$OVERLAY_FOUND" -eq 0 ]; then\n',
    '                for kmodfile in /lib/modules/*/kernel/fs/overlayfs/overlay.ko.zst /usr/lib/modules/*/kernel/fs/overlayfs/overlay.ko.zst; do\n',
    '                    if [ -f "$kmodfile" ]; then\n',
    '                        echo "casper: trying zstd decompress + insmod $kmodfile" >&2\n',
    '                        tmpko=/tmp/overlay.ko\n',
    '                        if zstd -d "$kmodfile" -o "$tmpko" 2>/dev/null && insmod "$tmpko" 2>&1; then\n',
    '                            OVERLAY_FOUND=1\n',
    '                            break\n',
    '                        fi\n',
    '                    fi\n',
    '                done\n',
    '            fi\n',
    '            if [ "$OVERLAY_FOUND" -eq 0 ]; then\n',
    '                echo "casper: listing all overlayfs modules found:" >&2\n',
    '                find /lib/modules /usr/lib/modules -path "*/overlayfs/*" -type f 2>/dev/null >&2\n',
    '                echo "casper: checking /proc/filesystems:" >&2\n',
    '                cat /proc/filesystems 2>/dev/null >&2\n',
    '                echo "casper: trying direct mount as last resort" >&2\n',
    '                mkdir -p /cow/upper /cow/work\n',
    '                mount -t overlay -o "upperdir=/cow/upper,lowerdir=/cow,workdir=/cow/work" overlay /cow 2>&1 >&2 || true\n',
    '                modprobe ${MP_QUIET} -b overlay 2>/dev/null || modprobe ${MP_QUIET} overlay 2>/dev/null || panic "/cow format specified as \'overlay\' and no support found"\n',
    '            fi\n',
    '        fi\n',
    '    fi\n',
]

target_line = '    modprobe "${MP_QUIET}" -b overlay || panic "/cow format specified as \'overlay\' and no support found"'

found = False
output = []
for i, line in enumerate(lines):
    if target_line in line or "modprobe" in line and "overlay" in line and "panic" in line:
        output.extend(new_lines)
        found = True
        print(f"Replaced line {i+1}: {line.strip()}")
    else:
        output.append(line)

if not found:
    print("ERROR: target line not found!")
    for i, line in enumerate(lines):
        if "overlay" in line and "modprobe" in line:
            print(f"  Candidate line {i+1}: {line.strip()}")
    sys.exit(1)

with open(CASPER, "w") as f:
    f.writelines(output)

print("PATCHED SUCCESSFULLY")
