#!/bin/bash
bash /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/rebuild-iso-v2.sh > /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/rebuild-log.txt 2>&1
echo "EXIT=$?"
tail -15 /mnt/c/Users/PC-1.DESKTOP-421EUGM/Downloads/carpentian/rebuild-log.txt