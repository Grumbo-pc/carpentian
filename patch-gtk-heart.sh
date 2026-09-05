#!/bin/bash
set -e

python3 << 'PYEOF'
import base64

# Heart SVG as data URI
heart_svg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16"><path d="M8 14 C8 14 1 9 1 5.5 C1 3 3 1 5.5 1 C7 1 7.8 1.8 8 2.5 C8.2 1.8 9 1 10.5 1 C13 1 15 3 15 5.5 C15 9 8 14 8 14Z" fill="black" stroke="none"/></svg>'''
heart_b64 = base64.b64encode(heart_svg.encode()).decode()
data_uri = f'url("data:image/svg+xml;base64,{heart_b64}")'

old = """/* Titlebar close/minimize/maximize buttons */
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

new = f"""/* Titlebar close/minimize/maximize buttons */
headerbar button.titlebutton {{
    padding: 2px 4px;
    min-height: 20px;
    min-width: 20px;
    border-radius: 0;
    background: linear-gradient(180deg, #f0f0f0, #d0d0d0);
    border: 1px solid #808080;
    box-shadow: inset 1px 1px 0 #ffffff, inset -1px -1px 0 #808080;
    color: #000000;
}}
headerbar button.titlebutton:hover {{
    background: linear-gradient(180deg, #f8f8f8, #e0e0e0);
}}
headerbar button.titlebutton:active {{
    background: linear-gradient(180deg, #b0b0b0, #c0c0c0);
    box-shadow: inset -1px -1px 0 #ffffff, inset 1px 1px 0 #808080;
}}
headerbar button.titlebutton.close {{
    -gtk-icon-source: none;
    background-image: {data_uri};
    background-repeat: no-repeat;
    background-position: center;
    background-size: 14px 14px;
    background-color: linear-gradient(180deg, #f0f0f0, #d0d0d0);
    border: 1px solid #808080;
    box-shadow: inset 1px 1px 0 #ffffff, inset -1px -1px 0 #808080;
    padding: 2px 4px;
}}
headerbar button.titlebutton.close:hover {{
    background-color: linear-gradient(180deg, #f8f8f8, #e0e0e0);
    background-image: {data_uri};
}}
headerbar button.titlebutton.close:active {{
    background-color: linear-gradient(180deg, #b0b0b0, #c0c0c0);
    box-shadow: inset -1px -1px 0 #ffffff, inset 1px 1px 0 #808080;
    background-image: {data_uri};
}}"""

with open("/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/gtk-3.0/gtk.css", "r") as f:
    content = f.read()

if "Titlebar close/minimize/maximize" in content:
    content = content.replace(old, new)
    with open("/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/gtk-3.0/gtk.css", "w") as f:
        f.write(content)
    print("GTK CSS patched with data URI heart")
else:
    print("Pattern not found!")
    print("Trying to find close section...")
    for i, line in enumerate(content.split('\n')):
        if 'titlebutton' in line.lower() or 'close' in line.lower():
            print(f"  Line {i+1}: {line}")
PYEOF
