#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== gtk_ui import test (compile only, no display) ==="
python3 -m py_compile /usr/lib/ubiquity/ubiquity/frontend/gtk_ui.py && echo "gtk_ui.py compiles OK"
echo "=== required python modules ==="
python3 -c "
import gi
gi.require_version(\"Gtk\", \"3.0\")
import gi.repository.Gtk
import apt, aptdaemon, dbus, im_guesser, ubiquity, osinfo
print(\"core imports OK\")
"
echo "=== ubiquity-dm WM detection order ==="
grep -n "interesting_paths\|wm\|metacity\|msgbox\|abort" /usr/bin/ubiquity-dm | head -30
'