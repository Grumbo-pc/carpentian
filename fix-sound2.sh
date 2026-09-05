#!/bin/bash
set -e
chroot /root/carpentian-build/chroot /bin/bash -c '
cat > /usr/share/glib-2.0/schemas/90-carpentian-sounds.gschema.override << "OVERRIDE"
[org.cinnamon.sounds]
switch-enabled=true
switch-file="/usr/share/sounds/Vicious/stereo/bell.oga"
close-enabled=true
close-file="/usr/share/sounds/Vicious/stereo/bell-window-system.oga"
map-enabled=true
map-file="/usr/share/sounds/Vicious/stereo/button-pressed.ogg"
minimize-enabled=true
minimize-file="/usr/share/sounds/Vicious/stereo/button-released.ogg"
maximize-enabled=true
maximize-file="/usr/share/sounds/Vicious/stereo/complete.oga"
unmaximize-enabled=true
unmaximize-file="/usr/share/sounds/Vicious/stereo/complete.oga"
tile-enabled=true
tile-file="/usr/share/sounds/Vicious/stereo/bell.oga"
login-enabled=true
login-file="/usr/share/sounds/Vicious/stereo/desktop-login.oga"
logout-enabled=true
logout-file="/usr/share/sounds/Vicious/stereo/desktop-logout.oga"
plug-enabled=true
plug-file="/usr/share/sounds/Vicious/stereo/device-added.oga"
unplug-enabled=true
unplug-file="/usr/share/sounds/Vicious/stereo/device-removed.oga"
notification-enabled=true
notification-file="/usr/share/sounds/Vicious/stereo/dialog-information.oga"

[org.cinnamon.desktop.sound]
theme-name="Vicious"
event-sounds=true
volume-sound-enabled=true
volume-sound-file="/usr/share/sounds/Vicious/stereo/audio-volume-change.oga"
OVERRIDE
echo "override written"
'