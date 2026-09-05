#!/usr/bin/env python3

# Copy full default cinnamon.css, then append only panel/titlebar Win9x overrides
default = "/root/carpentian-build/chroot/usr/share/cinnamon/theme/cinnamon.css"
target = "/root/carpentian-build/chroot/usr/share/themes/Carpentian-Win9x/cinnamon/cinnamon.css"

with open(default) as f:
    base = f.read()

overrides = """

/* ===========================================================
 * Carpentian Win9x Panel/Titlebar Overrides
 * =========================================================== */

/* Panel */
#panel {
    background-gradient-direction: vertical;
    background-gradient-start: #d4d0c8;
    background-gradient-end: #c0c0c0;
    color: #000000;
    border-bottom: 1px solid #808080;
    font-weight: bold;
}

#panel .clock {
    color: #000000;
    font-weight: bold;
}

.window-list-item-box {
    background-gradient-direction: vertical;
    background-gradient-start: #d4d0c8;
    background-gradient-end: #c0c0c0;
    color: #000000;
    border: 1px solid #808080;
    border-radius: 0;
    padding: 1px 4px;
}
.window-list-item-box:hover {
    background-gradient-start: #e8e8e8;
    background-gradient-end: #d0d0d0;
}
.window-list-item-box:focus {
    background-gradient-start: #000080;
    background-gradient-end: #1084d0;
    color: #ffffff;
}

#panel .app-menu-button {
    color: #000000;
    font-weight: bold;
}

/* Window decorations */
.window-frame {
    border: 2px solid #808080;
    border-radius: 0;
    box-shadow: 2px 2px 0px rgba(0,0,0,0.3);
}

.title-bar {
    background-gradient-direction: vertical;
    background-gradient-start: #000080;
    background-gradient-end: #1084d0;
    color: #ffffff;
    border: none;
    border-bottom: 1px solid #000040;
    border-radius: 0;
    padding: 2px 4px;
    font-weight: bold;
}

.window-frame:focus .title-bar {
    background-gradient-direction: vertical;
    background-gradient-start: #000080;
    background-gradient-end: #1084d0;
    color: #ffffff;
}

.window-frame:not(:focus) .title-bar {
    background-gradient-direction: vertical;
    background-gradient-start: #808080;
    background-gradient-end: #b0b0b0;
    color: #d0d0d0;
}

.close, .close:hover, .close:active,
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

.close:hover, .maximize:hover, .minimize:hover {
    background-gradient-start: #e8e8e8;
    background-gradient-end: #d0d0d0;
}
.close:active, .maximize:active, .minimize:active {
    background-gradient-start: #a0a0a0;
    background-gradient-end: #b0b0b0;
    border-style: inset;
}

.workspace-osd {
    color: #ffffff;
    font-size: 24pt;
    font-weight: bold;
}

.app-grid {
    background-color: rgba(0,0,0,0.85);
}
.app-grid .app-well-app .overview-icon {
    border-radius: 0;
    border: 2px solid transparent;
}
.app-grid .app-well-app .overview-icon:hover {
    border-color: #000080;
}
"""

with open(target, "w") as f:
    f.write(base + overrides)

with open(target) as f:
    print(f"Theme CSS: {len(f.readlines())} lines")
