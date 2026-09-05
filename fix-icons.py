import os

svg_content = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16">\n  <path d="M8 14 C8 14 1 9 1 5.5 C1 3 3 1 5.5 1 C7 1 7.8 1.8 8 2.5 C8.2 1.8 9 1 10.5 1 C13 1 15 3 15 5.5 C15 9 8 14 8 14Z" \n        fill="currentColor" stroke="none"/>\n</svg>\n'

base = "/root/carpentian-build/chroot/usr/share/icons"

paths = [
    f"{base}/Yaru/scalable/actions/window-close-symbolic.svg",
    f"{base}/Adwaita/scalable/actions/window-close-symbolic.svg",
    f"{base}/Yaru/symbolic/actions/window-close-symbolic.svg",
    f"{base}/Adwaita/symbolic/actions/window-close-symbolic.svg",
    f"{base}/Yaru/scalable/ui/window-close-symbolic.svg",
    f"{base}/Adwaita/scalable/ui/window-close-symbolic.svg",
    f"{base}/Yaru/symbolic/ui/window-close-symbolic.svg",
    f"{base}/Adwaita/symbolic/ui/window-close-symbolic.svg",
    f"{base}/Carpentian-Gnome/scalable/actions/window-close-symbolic.svg",
    f"{base}/Carpentian-Gnome/symbolic/actions/window-close-symbolic.svg",
    f"{base}/Carpentian-Gnome/scalable/ui/window-close-symbolic.svg",
    f"{base}/Carpentian-Gnome/symbolic/ui/window-close-symbolic.svg",
]

for p in paths:
    d = os.path.dirname(p)
    os.makedirs(d, exist_ok=True)
    with open(p, "w") as f:
        f.write(svg_content)
    print(f"Wrote {p}")

# Also copy SVGs for minimize and maximize
min_svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16">\n  <rect x="3" y="7" width="10" height="2" fill="currentColor"/>\n</svg>\n'

max_svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16">\n  <rect x="3" y="3" width="10" height="10" fill="none" stroke="currentColor" stroke-width="2"/>\n</svg>\n'

restore_svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16">\n  <rect x="5" y="5" width="8" height="8" fill="none" stroke="currentColor" stroke-width="2"/>\n  <rect x="2" y="2" width="8" height="8" fill="none" stroke="currentColor" stroke-width="2"/>\n</svg>\n'

for icon_name, svg in [("window-minimize-symbolic", min_svg), ("window-maximize-symbolic", max_svg), ("window-restore-symbolic", restore_svg)]:
    for theme in ["Yaru", "Adwaita", "Carpentian-Gnome"]:
        for subdir in ["scalable/actions", "scalable/ui", "symbolic/actions", "symbolic/ui"]:
            p = f"{base}/{theme}/{subdir}/{icon_name}.svg"
            d = os.path.dirname(p)
            os.makedirs(d, exist_ok=True)
            with open(p, "w") as f:
                f.write(svg)
    print(f"Wrote {icon_name} for all themes")
