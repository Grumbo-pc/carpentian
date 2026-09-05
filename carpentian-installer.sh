#!/bin/bash
# carpentian-installer.sh - Auto-launch ubiquity when booted via Install
# (only-ubiquity). Runs in the live desktop session to avoid ubiquity-dm's
# own X server black-screening. Uses the SAME launch command as the desktop
# "Install Carpentian" icon (upstream-proven). Logs everything.

LOG=/tmp/carpentian-installer.log
exec >"$LOG" 2>&1
echo "[$(date)] carpentian-installer starting uid=$(id -u) user=$(whoami) DISPLAY=$DISPLAY"

HAS_INSTALL=0
for x in $(cat /proc/cmdline); do
    case $x in
        only-ubiquity|maybe-ubiquity|automatic-ubiquity) HAS_INSTALL=1 ;;
    esac
done
echo "[$(date)] HAS_INSTALL=$HAS_INSTALL"
[ "$HAS_INSTALL" = "1" ] || exit 0

pgrep -x ubiquity >/dev/null 2>&1 && { echo "ubiquity already running, exit"; exit 0; }

# Wait until the desktop (cinnamon) is up and X socket exists.
for i in $(seq 1 120); do
    if [ -n "$DISPLAY" ] && [ -S "/tmp/.X11-unix/X${DISPLAY#:}" ] 2>/dev/null; then
        echo "[$(date)] X ready after ${i}s DISPLAY=$DISPLAY"
        break
    fi
    sleep 1
done
sleep 3
echo "[$(date)] launching ubiquity (icon mechanism)"

# Same command as /usr/share/applications/ubiquity.desktop
export DISPLAY DBUS_SESSION_BUS_ADDRESS XDG_DATA_DIRS XDG_RUNTIME_DIR GTK_THEME XAUTHORITY
nohup sudo --preserve-env=DBUS_SESSION_BUS_ADDRESS,XDG_DATA_DIRS,XDG_RUNTIME_DIR,GTK_THEME sh -c 'ubiquity gtk_ui' >/tmp/ubiquity-launch.log 2>&1 &
pid=$!
echo "[$(date)] launched pid=$pid"
exit 0
