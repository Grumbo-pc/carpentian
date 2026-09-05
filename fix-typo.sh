#!/bin/bash
sed -i "s/'innamon-session-logout/'cinnamon-session-logout/" /root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3/applet.js
grep -n 'cinnamon-session-logout' /root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3/applet.js
