#!/bin/bash
Perl -0777 -pi -e 's/\n                line=\$\(printf %s "\$line" \| sed.*?\)\n\(\(\\+\\+lines/\n        line=$(printf %s "$line" | sed '"'"'s\\x1b\\[[0-9;]*m//g'"'"')\n        ((++lines/gs' /root/carpentian-build/chroot/usr/bin/neofetch
bash -n /root/carpentian-build/chroot/usr/bin/neofetch && echo "syntax OK"
sed -n '/Calculate size of ascii/,/done <</p' /root/carpentian-build/chroot/usr/bin/neofetch