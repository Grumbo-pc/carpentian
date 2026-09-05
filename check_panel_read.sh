#!/bin/bash
echo "=== enabled-applets schema definition ==="
grep -A5 "enabled-applets" /usr/share/glib-2.0/schemas/org.cinnamon.gschema.xml 2>/dev/null | head -10

echo "=== panels-enabled schema definition ==="
grep -A5 "panels-enabled" /usr/share/glib-2.0/schemas/org.cinnamon.gschema.xml 2>/dev/null | head -10

echo "=== panels-height schema definition ==="
grep -A5 "panels-height" /usr/share/glib-2.0/schemas/org.cinnamon.gschema.xml 2>/dev/null | head -10

echo "=== How Cinnamon reads panels at startup ==="
grep -n "panels-enabled\|enabled-applets\|panels-enabled" /usr/share/cinnamon/js/ui/panel.js 2>/dev/null | head -20

echo "=== How appletManager reads enabled-applets ==="
grep -n "enabled-applets" /usr/share/cinnamon/js/ui/appletManager.js 2>/dev/null | head -15

echo "=== How layout reads panels ==="
grep -n "panels-enabled\|panels-enabled\|enabled-applets" /usr/share/cinnamon/js/ui/layout.js 2>/dev/null | head -15

echo "=== checkForUpgrade in appletManager ==="
grep -n -A20 "checkForUpgrade\|function.*upgrade" /usr/share/cinnamon/js/ui/appletManager.js 2>/dev/null | head -40
