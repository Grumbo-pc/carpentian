#!/bin/bash
set -e

chroot /root/carpentian-build/chroot /bin/bash -c 'cat > /usr/local/bin/espresso << "SCRIPT"
#!/bin/bash
# espresso - prevent sleep until next restart

if systemctl is-active espresso-inhibit.service &>/dev/null; then
    echo "espresso: already caffeinated"
    exit 0
fi

systemctl start espresso-inhibit.service
echo "espresso: sleep disabled until next restart"
SCRIPT
chmod +x /usr/local/bin/espresso

cat > /root/carpentian-build/chroot/etc/systemd/system/espresso-inhibit.service << "SERVICE"
[Unit]
Description=Caffeinate - block sleep until restart
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/systemd-inhibit --what=sleep:suspend:hibernate:handle-sleep-key:handle-lid-switch --who=espresso --why="Caffeinated" /bin/sleep infinity
RemainAfterExit=no

[Install]
WantedBy=multi-user.target
SERVICE

echo "espresso installed"
'

echo "Done"
