import os

css_path = "/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/cinnamon/cinnamon.css"
with open(css_path, "r") as f:
    content = f.read()

old = """button.titlebutton, button.titlebutton.close, button.titlebutton.maximize, button.titlebutton.minimize {
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
button.titlebutton.close:hover, button.titlebutton.maximize:hover, button.titlebutton.minimize:hover {
    background-gradient-start: #e8e8e8;
    background-gradient-end: #d0d0d0;
}
button.titlebutton.close:active, button.titlebutton.maximize:active, button.titlebutton.minimize:active {
    background-gradient-start: #a0a0a0;
    background-gradient-end: #b0b0b0;
    border-style: inset;
}"""

new = """button.titlebutton, button.titlebutton.close, button.titlebutton.maximize, button.titlebutton.minimize {
    color: #ffffff;
    background-color: #d4d0c8;
    background-image: linear-gradient(180deg, #d4d0c8 0%, #c0c0c0 100%);
    border: 1px outset #ffffff;
    border-radius: 0;
    padding: 2px 6px;
    min-width: 16px;
    min-height: 16px;
}
button.titlebutton.close:hover, button.titlebutton.maximize:hover, button.titlebutton.minimize:hover {
    background-image: linear-gradient(180deg, #e8e8e8 0%, #d0d0d0 100%);
}
button.titlebutton.close:active, button.titlebutton.maximize:active, button.titlebutton.minimize:active {
    background-image: linear-gradient(180deg, #a0a0a0 0%, #b0b0b0 100%);
    border: 1px inset #ffffff;
}"""

if old in content:
    content = content.replace(old, new)
    with open(css_path, "w") as f:
        f.write(content)
    print("CSS updated - using GTK3-compatible gradient syntax")
else:
    print("Pattern not found!")
    lines = content.split("\n")
    for i in range(2184, min(2215, len(lines))):
        print(f"{i+1}: {lines[i]}")
