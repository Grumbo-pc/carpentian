#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== ubiquity.service ==="
cat /usr/lib/systemd/system/ubiquity.service
echo "=== is it enabled? ==="
systemctl is-enabled ubiquity.service 2>&1
echo "=== wants/requires refs ==="
grep -rln "ubiquity.service" /usr/lib/systemd /etc/systemd 2>/dev/null | grep -v "ubiquity.service$"
echo "=== lightdm autostart/session for only-ubiquity? ==="
grep -rn "only-ubiquity\|ubiquity" /etc/lightdm/ /usr/share/lightdm/ 2>/dev/null | head
'