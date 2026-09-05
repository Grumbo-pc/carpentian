#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
export PYTHONPATH=/usr/lib/ubiquity
echo "=== import all plugins ==="
python3 - <<PYEOF
import importlib, glob, os
os.chdir("/usr/lib/ubiquity")
ok=0; fail=0
for p in sorted(glob.glob("/usr/lib/ubiquity/plugins/*.py")):
    m = "ubiquity.plugins." + os.path.basename(p)[:-3]
    try:
        importlib.import_module(m)
        ok+=1
    except Exception as e:
        fail+=1
        print("FAIL", m, "->", type(e).__name__, str(e)[:100])
print(f"OK={ok} FAIL={fail}")
PYEOF
echo "=== ubiquity --help (headless dry run; will exit with usage) ==="
export PYTHONPATH=/usr/lib/ubiquity
timeout 10 python3 /usr/lib/ubiquity/bin/ubiquity --help 2>&1 | head -20
'