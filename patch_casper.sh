#!/bin/bash
# Patch the casper script to fallback to insmod if modprobe fails
CASPER="/root/carpentian-build/chroot/usr/share/initramfs-tools/scripts/casper"
cp "$CASPER" "${CASPER}.bak"

python3 << 'PYEOF'
with open("/root/carpentian-build/chroot/usr/share/initramfs-tools/scripts/casper", "r") as f:
    content = f.read()

old_line = '''    modprobe "${MP_QUIET}" -b overlay || panic "/cow format specified as 'overlay' and no support found"'''

new_block = '''    # Try modprobe with blacklist, then without, then insmod fallback
    if ! modprobe ${MP_QUIET} -b overlay 2>/dev/null; then
        echo "casper: modprobe -b overlay failed, trying without blacklist" >&2
        if ! modprobe ${MP_QUIET} overlay 2>/dev/null; then
            echo "casper: modprobe overlay failed, trying insmod" >&2
            OVERLAY_FOUND=0
            for kmodfile in /lib/modules/*/kernel/fs/overlayfs/overlay.ko* \
                            /usr/lib/modules/*/kernel/fs/overlayfs/overlay.ko*; do
                if [ -f "$kmodfile" ]; then
                    echo "casper: trying insmod $kmodfile" >&2
                    if insmod "$kmodfile" 2>&1; then
                        OVERLAY_FOUND=1
                        break
                    fi
                fi
            done
            if [ "$OVERLAY_FOUND" -eq 0 ]; then
                panic "/cow format specified as 'overlay' and no support found"
            fi
        fi
    fi'''

if old_line in content:
    content = content.replace(old_line, new_block)
    with open("/root/carpentian-build/chroot/usr/share/initramfs-tools/scripts/casper", "w") as f:
        f.write(content)
    print("CASPER SCRIPT PATCHED SUCCESSFULLY")
else:
    print("OLD LINE NOT FOUND - searching:")
    for i, line in enumerate(content.split('\n'), 1):
        if 'overlay' in line.lower() and ('modprobe' in line.lower() or 'panic' in line.lower()):
            print(f"  Line {i}: {line}")
PYEOF
