#!/usr/bin/env python3

css_path = "/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/cinnamon/cinnamon.css"
override = """

/* ===========================================================
 * Carpentian Win9x Menu Overrides
 * =========================================================== */

.menu {
    background-color: #c0c0c0;
    border: 3px outset #dfdfdf;
    border-radius: 0;
    color: #000000;
}

.menu-favorites-box {
    background-color: #c0c0c0;
    border-right: 2px outset #dfdfdf;
    border-radius: 0;
    padding: 4px;
}
.menu-favorites-button {
    padding: 6px;
    border-radius: 0;
    border: 1px solid transparent;
}
.menu-favorites-button:hover {
    background-color: #000080;
    color: #ffffff;
    border-radius: 0;
}

.menu-categories-box {
    background-color: #000080;
    padding: 4px;
    border-right: 3px outset #808080;
}
.menu-category-button {
    padding: 6px 12px;
    color: #ffffff;
    border-radius: 0;
    border: 1px solid transparent;
    min-height: 28px;
}
.menu-category-button:hover {
    background-color: #1084d0;
    border-radius: 0;
}
.menu-category-button-selected {
    background-color: #1084d0;
    color: #ffffff;
    border-radius: 0;
    box-shadow: none;
}
.menu-category-button-label {
    color: #ffffff;
    font-size: 13px;
    font-weight: bold;
}
.menu-category-button-greyed {
    color: #808080;
    font-style: italic;
    border-radius: 0;
}

.menu-applications-outer-box {
    background-color: #dfdfdf;
    border-radius: 0;
    padding: 4px;
}
.menu-applications-inner-box {
    background-color: #dfdfdf;
    margin: 0;
}
.menu-application-button {
    padding: 4px 8px;
    border-radius: 0;
    border: 1px solid transparent;
}
.menu-application-button:hover {
    background-color: #000080;
    border-radius: 0;
    box-shadow: none;
}
.menu-application-button-label {
    color: #000000;
    font-size: 12px;
}
.menu-application-button:hover .menu-application-button-label {
    color: #ffffff;
}
.menu-application-button-selected {
    background-color: #000080;
    color: #ffffff;
    border-radius: 0;
    box-shadow: none;
}

.menu-search-box {
    padding: 4px 8px;
}
#menu-search-entry {
    background-color: #ffffff;
    border: 2px inset #808080;
    border-radius: 0;
    color: #000000;
    padding: 4px 8px;
    font-size: 13px;
    width: 250px;
    box-shadow: none;
}
#menu-search-entry:focus {
    border: 2px inset #808080;
    background-color: #ffffff;
    color: #000000;
    box-shadow: none;
}

.menu-top-box {
    spacing: 8px;
}

.menu-selected-app-box {
    background-color: #c0c0c0;
    border-top: 2px outset #dfdfdf;
    padding: 4px 12px;
}
.menu-selected-app-title {
    color: #000000;
    font-weight: bold;
}
.menu-selected-app-description {
    color: #404040;
}

.menu-systembuttons-box {
    background-color: #c0c0c0;
    border-top: 2px outset #dfdfdf;
    padding: 4px;
}
"""

with open(css_path, "a") as f:
    f.write(override)

with open(css_path) as f:
    lines = f.readlines()
print(f"Total lines: {len(lines)}")
