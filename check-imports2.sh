#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
export PYTHONPATH=/usr/lib/ubiquity
echo "=== top-level given to check ==="
python3 - <<PYEOF 2>&1 | tail -30
import importlib
mods = ["ubiquity", "ubiquity.casper", "ubiquity.frontend", "ubiquity.frontend.gtk_ui",
        "ubiquity.components.console_setup", "ubiquity.components.filesystem",
        "ubiquity.components.grubinstaller", "ubiquity.components.misc",
        "ubiquity.components.timezone", "ubiquity.components.user_setup",
        "ubiquity.components.tz_ui", "ubiquity.components.keyboard", "ubiquity.components.language",
        "ubiquity.components.install", "ubiquity.components.save_original_gtk_settings"]
for m in mods:
    try:
        importlib.import_module(m)
        print("OK  ", m)
    except Exception as e:
        print("FAIL", m, "->", type(e).__name__, e)
PYEOF
'