#!/bin/bash
set -e

GTK_CSS="/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/gtk-3.0/gtk.css"

python3 << 'PYEOF'
with open("/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/gtk-3.0/gtk.css", "r") as f:
    content = f.read()

# Add close button heart override at the end
addition = """

/* Titlebar close/minimize/maximize buttons */
headerbar button.titlebutton {
    padding: 0;
    min-height: 20px;
    min-width: 20px;
    border-radius: 0;
}
headerbar button.titlebutton.close {
    background: transparent;
    border: none;
    box-shadow: none;
    -gtk-icon-source: -gtk-icontheme("window-close-symbolic");
    color: #dfdfdf;
}
headerbar button.titlebutton.close:hover {
    color: #fdd9e8;
}
headerbar button.titlebutton.close:active {
    color: #c00060;
}
headerbar button.titlebutton.minimize,
headerbar button.titlebutton.maximize {
    color: #ffffff;
}
headerbar button.titlebutton.minimize:hover,
headerbar button.titlebutton.maximize:hover {
    color: #fdd9e8;
}
"""

if "Titlebar close/minimize/maximize" not in content:
    content += addition
    with open("/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/gtk-3.0/gtk.css", "w") as f:
        f.write(content)
    print("GTK CSS patched successfully")
else:
    print("Already patched")
PYEOF
