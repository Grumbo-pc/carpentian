#!/bin/bash
APPLET="/root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3/applet.js"
sed -i 's/this\.modal\.set_position(monitor\.x, monitor\.y);/let panelH = Main.panel.actor.height;\n        this.modal.set_position(monitor.x, monitor.y);/' "$APPLET"
sed -i 's/this\.modal\.set_size(monitor\.width, monitor\.height);/this.modal.set_size(monitor.width, monitor.height - panelH);/' "$APPLET"
grep -n 'set_position\|set_size' "$APPLET" | head -5
