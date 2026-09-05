#!/bin/bash
# Robust patch for casper overlay loading
CASPER="/root/carpentian-build/chroot/usr/share/initramfs-tools/scripts/casper"

python3 << 'PYEOF'
with open("/root/carpentian-build/chroot/usr/share/initramfs-tools/scripts/casper", "r") as f:
    lines = f.readlines()

new_block = [
    "    # Try modprobe with blacklist, then without, then insmod fallback\n",
    "    if ! modprobe ${MP_QUIET} -b overlay 2>/dev/null; then\n",
    "        echo \"casper: modprobe -b overlay failed, trying without blacklist\" >&2\n",
    "        if ! modprobe ${MP_QUIET} overlay 2>/dev/null; then\n",
    "            echo \"casper: modprobe overlay failed, trying insmod\" >&2\n",
    "            OVERLAY_FOUND=0\n",
    "            for kmodfile in /lib/modules/*/kernel/fs/overlayfs/overlay.ko* /usr/lib/modules/*/kernel/fs/overlayfs/overlay.ko*; do\n",
    "                if [ -f \"$kmodfile\" ]; then\n",
    "                    echo \"casper: trying insmod $kmodfile\" >&2\n",
    "                    if insmod \"$kmodfile\" 2>&1; then\n",
    "                        OVERLAY_FOUND=1\n",
    "                        break\n",
    "                    fi\n",
    "                fi\n",
    "            done\n",
    "            if [ \"$OVERLAY_FOUND\" -eq 0 ]; then\n",
    "                # Last resort: try to decompress .zst and insmod\n",
    "                for kmodfile in /lib/modules/*/kernel/fs/overlayfs/overlay.ko.zst /usr/lib/modules/*/kernel/fs/overlayfs/overlay.ko.zst; do\n",
    "                    if [ -f \"$kmodfile\" ]; then\n",
    "                        echo \"casper: trying zstd decompress + insmod $kmodfile\" >&2\n",
    "                        tmpko=/tmp/overlay.ko\n",
    "                        if zstd -d \"$kmodfile\" -o \"$tmpko\" 2>/dev/null && insmod \"$tmpko\" 2>&1; then\n",
    "                            OVERLAY_FOUND=1\n",
    "                            break\n",
    "                        fi\n",
    "                    fi\n",
    "                done\n",
    "            fi\n",
    "            if [ \"$OVERLAY_FOUND\" -eq 0 ]; then\n",
    "                # Final attempt: try loading all modules in overlayfs dir\n",
    "                echo \"casper: listing overlayfs modules:\" >&2\n",
    "                find /lib/modules /usr/lib/modules -path '*/overlayfs/*' -type f 2>/dev/null >&2\n",
    "                panic \"/cow format specified as 'overlay' and no support found\"\n",
    "            fi\n",
    "        fi\n",
    "    fi\n",
    "\n",
]

# Find the patched block and replace it
output = []
skip_until = None
for i, line in enumerate(lines):
    if skip_until is not None:
        if line.strip() == '' and i > skip_until:
            skip_until = None
            output.extend(new_block)
        continue
    if 'Try modprobe with blacklist' in line:
        skip_until = i
        continue
    output.append(line)

with open("/root/carpentian-build/chroot/usr/share/initramfs-tools/scripts/casper", "w") as f:
    f.writelines(output)

print("CASPER PATCHED SUCCESSFULLY")
PYEOF
