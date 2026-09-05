#!/bin/bash
set -e

chroot /root/carpentian-build/chroot /bin/bash -c 'cat > /tmp/fix_bashrc.py << '"'"'PYEOF'"'"'
import re

with open("/etc/bash.bashrc", "r") as f:
    content = f.read()

old = """# Easter egg: "please please please" and "plsplspls" act as sudo
please() {
  if [ "$1" = "please" ] && [ "$2" = "please" ]; then
    shift 2
    sudo "$@"
  elif [ -z "$1" ]; then
    echo "Usage: please please please <command>"
  else
    command please "$@"
  fi
}
complete -F _complete_alias please 2>/dev/null

plsplspls() {
  sudo "$@"
}"""

new = """# Easter egg: "please please please" and "plsplspls" act as sudo
_carpentian_fail_msgs=(
  "I can'"'"'t relate to desperation..."
  "Soft skin and I taste like text errors."
  "Heartbreak is one thing, but a bad password is another."
  "Don'"'"'t smile because it happened, cry because you got it wrong."
)
_carpentian_fail() {
  local msg="${_carpentian_fail_msgs[$(( RANDOM % ${#_carpentian_fail_msgs[@]} ))]}"
  printf "\\n  \\033[1;31m%s\\033[0m\\n\\n" "$msg"
}
please() {
  if [ "$1" = "please" ] && [ "$2" = "please" ]; then
    shift 2
    sudo "$@"
    local rc=$?
    if [ $rc -ne 0 ]; then
      _carpentian_fail
      return $rc
    fi
  elif [ -z "$1" ]; then
    echo "Usage: please please please <command>"
  else
    command please "$@"
  fi
}
complete -F _complete_alias please 2>/dev/null

plsplspls() {
  sudo "$@"
  local rc=$?
  if [ $rc -ne 0 ]; then
    _carpentian_fail
    return $rc
  fi
}"""

if old in content:
    content = content.replace(old, new)
    with open("/etc/bash.bashrc", "w") as f:
        f.write(content)
    print("bash.bashrc updated")
else:
    print("Old pattern not found!")
    idx = content.find("# Easter egg")
    print(content[idx:idx+500])

PYEOF
python3 /tmp/fix_bashrc.py
'

echo "Done"
