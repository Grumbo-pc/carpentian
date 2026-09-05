#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
export PYTHONPATH=/usr/lib/ubiquity
python3 - <<PYEOF 2>&1 | tail -12
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GdkPixbuf, Pango, GLib
import cairo
print("GTK3 + cairo OK")
try:
    import aptdaemon.client
    print("aptdaemon OK")
except Exception as e:
    print("aptdaemon missing:", e)
try:
    from ubiquity.frontend import gtk_ui
    print("gtk_ui import OK")
except Exception as e:
    print("gtk_ui FAIL:", type(e).__name__, e)
PYEOF
echo "=== ubiquity-casper hooks in initramfs (post-install) ==="
dpkg -L ubiquity-casper | grep -iE "initramfs|casper-bottom|\.service|\.desktop"
'