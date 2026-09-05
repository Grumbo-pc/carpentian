#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== gtk_ui imports ==="
sed -n "1,60p" /usr/lib/ubiquity/ubiquity/frontend/gtk_ui.py | grep -E "^import|^from|^    import" | head -40
echo "=== im_guesser location ==="
find /usr/lib/ubiquity -name "im_guesser*" 2>/dev/null
python3 -c "import ubiquity.im_guesser; print(\"ubiquity.im_guesser OK\")" 2>&1 | tail -1
echo "=== any missing top-level imports across ubiquity pkg? ==="
python3 - <<PYEOF 2>&1 | tail -20
import importlib
mods = ["ubiquity", "ubiquity.frontend.gtk_ui", "ubiquity.casper", "ubiquity.components.console_setup",
        "ubiquity.components.filesystem", "ubiquity.components.grubinstaller", "ubiquity.components.misc",
        "ubiquity.components.timezone", "ubiquity.components.user_setup"]
for m in mods:
    try:
        importlib.import_module(m)
        print("OK  ", m)
    except Exception as e:
        print("FAIL", m, "->", type(e).__name__, e)
PYEOF
'