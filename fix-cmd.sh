#!/bin/bash
sed -i "s|Util.spawnCommandLine('cinnamon-session-quit');|Util.spawnCommandLine('cinnamon-session-quit --power-off');|" /root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3/applet.js
grep -n 'cinnamon-session-quit' /root/carpentian-build/chroot/usr/share/cinnamon/applets/app-drawer@mostlynick3/applet.js
