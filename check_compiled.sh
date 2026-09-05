#!/bin/bash
echo "=== gschemas.compiled date ==="
ls -la /usr/share/glib-2.0/schemas/gschemas.compiled

echo "=== 11_cinnamon.gschema.override date ==="
ls -la /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override

echo "=== Are they the same date? ==="
COMPILED_DATE=$(stat -c %Y /usr/share/glib-2.0/schemas/gschemas.compiled)
OVERRIDE_DATE=$(stat -c %Y /usr/share/glib-2.0/schemas/11_cinnamon.gschema.override)
if [ "$COMPILED_DATE" -gt "$OVERRIDE_DATE" ]; then
    echo "gschemas.compiled is NEWER than override - OK"
else
    echo "gschemas.compiled is OLDER - NEEDS RECOMPILATION!"
fi

echo ""
echo "=== Verify our override is IN the compiled schema ==="
python3 -c "
import gi
gi.require_version('Gio', '2.0')
from gi.repository import Gio
s = Gio.Settings(schema='org.cinnamon')
print('enabled-applets:', s.get_value('enabled-applets').unpack()[:2] if s.get_value('enabled-applets') else 'EMPTY')
print('panels-enabled:', s.get_value('panels-enabled').unpack())
print('panels-height:', s.get_value('panels-height').unpack())
" 2>&1
