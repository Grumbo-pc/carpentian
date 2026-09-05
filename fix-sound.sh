#!/bin/bash
set -e

chroot /root/carpentian-build/chroot /bin/bash -c '
python3 << '"'"'PYEOF'"'"'
path = "/etc/dconf/db/local.d/01-carpentian"
with open(path) as f:
    content = f.read()

old = """[org/cinnamon/desktop/sounds]
theme-name='"'"'Vicious'"'"'
event-sounds=true
input-feedback-sounds=true"""

new = """[org/cinnamon/desktop/sound]
theme-name='"'"'Vicious'"'"'
event-sounds=true
input-feedback-sounds=true
volume-sound-enabled=true
volume-sound-file='"'"'/usr/share/sounds/Vicious/stereo/audio-volume-change.oga'"'"'"""

if "desktop/sounds" in content:
    content = content.replace(old, new)
    with open(path, "w") as f:
        f.write(content)
    print("Fixed plural -> singular schema path")
else:
    print("Pattern not found, checking current state")
    # Show the sounds block
    for line in content.split("\n"):
        if "sound" in line and "desktop" in line:
            print(repr(line))
PYEOF
dconf update
'

echo "=== verify ==="
grep -n "sound" /root/carpentian-build/chroot/etc/dconf/db/local.d/01-carpentian