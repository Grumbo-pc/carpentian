#!/bin/bash
LOG=/tmp/carpentian-calamares.log
exec >"$LOG" 2>&1
echo "[$(date)] carpentian-calamares starting uid=$(id -u) user=$(whoami) DISPLAY=$DISPLAY"
HAS_INSTALL=0
for x in $(cat /proc/cmdline); do
    case $x in only-ubiquity|maybe-ubiquity|automatic-ubiquity) HAS_INSTALL=1 ;; esac
done
[ "$HAS_INSTALL" = "1" ] || exit 0
pgrep -x calamares >/dev/null 2>&1 && { exit 0; }
for i in $(seq 1 120); do
    if [ -n "$DISPLAY" ] && [ -S "/tmp/.X11-unix/X${DISPLAY#:}" ] 2>/dev/null; then break; fi
    sleep 1
done
sleep 3
export DISPLAY DBUS_SESSION_BUS_ADDRESS XDG_DATA_DIRS XDG_RUNTIME_DIR
nohup sudo --preserve-env=DISPLAY,DBUS_SESSION_BUS_ADDRESS,XDG_DATA_DIRS,XDG_RUNTIME_DIR calamares -D8 >/tmp/calamares-launch.log 2>&1 &
exit 0
