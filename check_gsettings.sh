#!/bin/bash
echo "=== gsettings defaults ==="
gsettings list-recursively org.cinnamon | grep -E "enabled-applets|panels-enabled|panels-height|next-applet-id"
echo ""
echo "=== exact values ==="
gsettings get org.cinnamon enabled-applets
gsettings get org.cinnamon panels-enabled
gsettings get org.cinnamon panels-height
gsettings get org.cinnamon next-applet-id
