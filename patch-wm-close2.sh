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

old = """.close {
    background-image: url("data:image/svg+xml;base64,"""

# Find and replace the entire close section
old_close = """.close, .close:hover, .close:active,
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

# Let me find the exact boundaries
lines = content.split('\n')
start = None
end = None
for i, line in enumerate(lines):
    if '.close, .close:hover' in line and 'minimize' in line:
        start = i
    if start is not None and line.strip() == '' and i > start + 5:
        # Check if next non-empty line is not part of close section
        for j in range(i+1, min(i+5, len(lines))):
            if lines[j].strip() and not lines[j].strip().startswith('.'):
                end = i
                break
            elif lines[j].strip().startswith('.'):
                end = i
                break

# Just find the whole block
old_block = """    icon-size: 14px;
}
.close {
    background-image: url("data:image/svg+xml;base64,"""

if old_block not in content:
    print("Trying alternative approach...")
    # Find and replace everything from icon-size: 14px through the close section
    import re
    pattern = r'icon-size: 14px;\n\}.*?border-style: inset;\n\}'
    match = re.search(pattern, content, re.DOTALL)
    if match:
        new_block = f"""    icon-size: 14px;
}}
.close, .close:hover, .close:active {{
    background-image: url("data:image/svg+xml;base64,{heart_b64}");
    background-repeat: no-repeat;
    background-position: center;
    color: transparent;
    icon-size: 0px;
}}
.close:hover {{
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
}}"""
        content = content[:match.start()] + new_block + content[match.end():]
        with open("/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/cinnamon/cinnamon.css", "w") as f:
            f.write(content)
        print("Cinnamon CSS patched with regex")
    else:
        print("No match found!")
else:
    print("Found exact match")
PYEOF
