import os

# Heart SVG with dark fill to be visible on gray button background
svg_content = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16">\n  <path d="M8 14 C8 14 1 9 1 5.5 C1 3 3 1 5.5 1 C7 1 7.8 1.8 8 2.5 C8.2 1.8 9 1 10.5 1 C13 1 15 3 15 5.5 C15 9 8 14 8 14Z" \n        fill="currentColor" stroke="none"/>\n</svg>\n'

base = "/root/carpentian-build/chroot/usr/share/icons"
themes = ["Carpentian-Gnome", "Yaru", "Adwaita"]
subdirs = ["scalable/actions", "symbolic/actions", "scalable/ui", "symbolic/ui"]

for theme in themes:
    for subdir in subdirs:
        p = f"{base}/{theme}/{subdir}/window-close-symbolic.svg"
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w") as f:
            f.write(svg_content)
