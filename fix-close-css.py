
with open('/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/cinnamon/cinnamon.css', 'r') as f:
    content = f.read()

# Find the section to replace
start_marker = '.close, .maximize, .minimize {'
start_idx = content.find(start_marker)
if start_idx == -1:
    print("Start not found")
    exit(1)

# Find end of .close:active block
end_marker = '    border-style: inset;\n}'
end_search_from = start_idx
close_active_idx = content.find('.close:active', start_idx)
if close_active_idx != -1:
    end_idx = content.find(end_marker, close_active_idx)
    if end_idx != -1:
        end_idx += len(end_marker)
    else:
        print("End not found")
        exit(1)
else:
    print(".close:active not found")
    exit(1)

# Check what's in the section
section = content[start_idx:end_idx]
print("Found section:")
print(section[:300])

new_section = """.close, .maximize, .minimize {
    color: #ffffff;
    background-gradient-direction: vertical;
    background-gradient-start: #d4d0c8;
    background-gradient-end: #c0c0c0;
    border: 1px outset #ffffff;
    border-radius: 0;
    padding: 2px 6px;
    min-width: 16px;
    min-height: 16px;
}
.close:hover, .maximize:hover, .minimize:hover {
    background-gradient-start: #e8e8e8;
    background-gradient-end: #d0d0d0;
}
.close:active, .maximize:active, .minimize:active {
    background-gradient-start: #a0a0a0;
    background-gradient-end: #b0b0b0;
    border-style: inset;
}
"""

content = content[:start_idx] + new_section + content[end_idx:]

with open('/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/cinnamon/cinnamon.css', 'w') as f:
    f.write(content)
print("CSS fixed - close button restored to normal, icon theme handles the icon")
PYEOF
