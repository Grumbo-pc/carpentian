#!/bin/bash
C=/root/carpentian-build/chroot
echo "=== DM.__init__ + helpers 130-240 ==="
sed -n '130,240p' $C/usr/bin/ubiquity-dm
echo "=== drop_privileges / server_preexec ==="
grep -n "def drop_privileges\|def server_preexec\|def run_hooks\|def active_vt" $C/usr/bin/ubiquity-dm