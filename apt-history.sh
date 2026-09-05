#!/bin/bash
chroot /root/carpentian-build/chroot /bin/bash -c '
echo "=== apt history (last ops) ==="
tail -60 /var/log/apt/history.log 2>/dev/null | grep -E "^(Start-Date|Commandline|Install:|Remove:|Purge:)" | tail -30
'