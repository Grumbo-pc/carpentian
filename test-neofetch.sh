#!/bin/bash
# Run neofetch in chroot to check output, using ascii backend, minimal deps
chroot /root/carpentian-build/chroot /bin/bash -c '
unset TERM; export TERM=xterm
neofetch 2>/dev/null | cat -A | sed "s/\^\[/ESC[/g" | head -30
'