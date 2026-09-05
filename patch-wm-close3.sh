#!/bin/bash
set -e

python3 << 'PYEOF'
import base64

heart_svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 14 14" width="14" height="14"><path d="M7 12.5 C7 12.5 1 8 1 5 C1 3 2.5 1.5 4.5 1.5 C5.8 1.5 6.5 2.3 7 3 C7.5 2.3 8.2 1.5 9.5 1.5 C11.5 1.5 13 3 13 5 C13 8 7 12.5 7 12.5Z" fill="black"/></svg>'
heart_b64 = base64.b64encode(heart_svg.encode()).decode()

heart_hover_svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 14 14" width="14" height="14"><path d="M7 12.5 C7 12.5 1 8 1 5 C1 3 2.5 1.5 4.5 1.5 C5.8 1.5 6.5 2.3 7 3 C7.5 2.3 8.2 1.5 9.5 1.5 C11.5 1.5 13 3 13 5 C13 8 7 12.5 7 12.5Z" fill="#fdd9e8"/></svg>'
heart_hover_b64 = base64.b64encode(heart_hover_svg.encode()).decode()

with open("/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/cinnamon/cinnamon.css", "r") as f:
    content = f.read()

old = """.close, .close:hover, .close:active,
.maximize, .maximize:hover, .maximize:active,
.minimize, .minimize:hover, .minimize:active {
    color: #ffffff;
    background-gradient-direction: vertical;
    background-gradient-start: #d4d0c8;
    background-gradient-end: #c0c0c0;
    border: 1px outset #ffffff;
    border-radius: 0;
    padding: 2px 6px;
    min-width: 16px;
    min-height: 16px;
    icon-size: 14px;
}
.close {
    background-image: url("data:image/svg+xml;base64,"""

# Find position of the old block
idx = content.find('.close, .close:hover, .close:active,\n.maximize')
if idx == -1:
    print("Pattern not found!")
    exit(1)

# Find the end of the close section (the next empty line after .maximize:active block)
rest = content[idx:]
# Find the pattern end - look for the maximize:active block end
end_marker = """.maximize:active, .minimize:active {
    background-gradient-start: #a0a0a0;
    background-gradient-end: #b0b0b0;
    border-style: inset;
}
"""
end_idx = rest.find(end_marker)
if end_idx == -1:
    print("End pattern not found!")
    exit(1)

end_pos = idx + end_idx + len(end_marker)

new_block = f""".close, .maximize, .minimize {{
    color: #ffffff;
    background-gradient-direction: vertical;
    background-gradient-start: #d4d0c8;
    background-gradient-end: #c0c0c0;
    border: 1px outset #ffffff;
    border-radius: 0;
    padding: 2px 6px;
    min-width: 16px;
    min-height: 16px;
}}
.close {{
    color: transparent;
    icon-size: 0px;
    background-image: url("data:image/svg+xml;base64,{heart_b64}");
    background-repeat: no-repeat;
    background-position: center;
}}
.close:hover {{
    color: transparent;
    icon-size: 0px;
    background-image: url("data:image/svg+xml;base64,{heart_hover_b64}");
    background-repeat: no-repeat;
    background-position: center;
    background-gradient-start: #e8e8e8;
    background-gradient-end: #d0d0d0;
}}
.close:active {{
    background-gradient-start: #a0a0a0;
    background-gradient-end: #b0b0b0;
    border-style: inset;
}}
.maximize:hover, .minimize:hover {{
    background-gradient-start: #e8e8e8;
    background-gradient-end: #d0d0d0;
}}
.maximize:active, .minimize:active {{
    background-gradient-start: #a0a0a0;
    background-gradient-end: #b0b0b0;
    border-style: inset;
}}
"""

content = content[:idx] + new_block + content[end_pos:]

with open("/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/cinnamon/cinnamon.css", "w") as f:
    f.write(content)
print("Cinnamon CSS patched - close button should now show heart")
PYEOF
