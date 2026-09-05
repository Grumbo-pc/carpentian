#!/bin/bash
cd /root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3
sed -i 's/Applet\.IconApplet/Applet.TextIconApplet/g' applet.js
sed -i 's/set_applet_icon_symbolic_name/set_applet_icon_name/g' applet.js
sed -i 's/open-menu-symbolic/carpentian-menu/g' applet.js
head -20 applet.js
