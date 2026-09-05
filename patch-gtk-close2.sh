#!/bin/bash
set -e

python3 << 'PYEOF'
with open("/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/gtk-3.0/gtk.css", "r") as f:
    content = f.read()

old = """/* Titlebar close/minimize/maximize buttons */
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
}"""

new = """/* Titlebar close/minimize/maximize buttons */
headerbar button.titlebutton {
    padding: 2px 4px;
    min-height: 20px;
    min-width: 20px;
    border-radius: 0;
    background: linear-gradient(180deg, #f0f0f0, #d0d0d0);
    border: 1px solid #808080;
    box-shadow: inset 1px 1px 0 #ffffff, inset -1px -1px 0 #808080;
    color: #000000;
    -gtk-icon-source: -gtk-icontheme("window-close-symbolic");
}
headerbar button.titlebutton:hover {
    background: linear-gradient(180deg, #f8f8f8, #e0e0e0);
}
headerbar button.titlebutton:active {
    background: linear-gradient(180deg, #b0b0b0, #c0c0c0);
    box-shadow: inset -1px -1px 0 #ffffff, inset 1px 1px 0 #808080;
}"""

if "Titlebar close/minimize/maximize" in content:
    content = content.replace(old, new)
    with open("/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/gtk-3.0/gtk.css", "w") as f:
        f.write(content)
    print("GTK CSS patched successfully")
else:
    print("Pattern not found!")
PYEOF
