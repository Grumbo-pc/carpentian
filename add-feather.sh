#!/bin/bash
set -e

chroot /root/carpentian-build/chroot /bin/bash -c 'cat >> /etc/bash.bashrc << '"'"'BASHRC'"'"'

# Easter egg: "feather" acts like rm (it drifts away)
feather() {
  rm "$@"
}
alias feather="rm"
BASHRC
echo "feather alias added"'

echo "Done"
