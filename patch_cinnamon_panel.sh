#!/bin/bash
set -ex
CHROOT=/root/carpentian-build/chroot

echo "=== Step 1: Verify the gsettings default is correct ==="
chroot "$CHROOT" /bin/bash -c 'gsettings get org.cinnamon enabled-applets' 2>&1

echo "=== Step 2: Patch panel.js checkPanelUpgrade to force our layout ==="
# The checkPanelUpgrade function can interfere. Let's make it always set our layout.
PANEL_JS="$CHROOT/usr/share/cinnamon/js/ui/panel.js"

# Backup
cp "$PANEL_JS" "${PANEL_JS}.bak"

# Replace the entire checkPanelUpgrade function to always set our custom layout
python3 -c "
import re

with open('$PANEL_JS', 'r') as f:
    content = f.read()

# Find and replace checkPanelUpgrade
old_func = '''function checkPanelUpgrade()
{
    let oldLayout = global.settings.get_string(\"desktop-layout\");

    let doIt = false;

    /* GLib >= 2.4 has get_user_value, use that if possible - this being null
     * indicates either the user never changed from the default \"traditional\"
     * panel layout, or else this upgrade has already been performed (since
     * with this set of patches, its default value goes from traditional to nothing.)
     * Either way, we don't need to do anything in this case.  With glib < 2.4,
     * we instead check if the value is set to \"\" - either by result of the new
     * default, or by this upgrade already having been run.
     */

    try {
        doIt = (global.settings.get_user_value(\"desktop-layout\") != null)
    } catch (e) {
        doIt = (global.settings.get_string(\"desktop-layout\") != \"\");
    }

    if (!doIt)
        return;

    switch (oldLayout) {
        case \"flipped\":
            setPanelsEnabledList([\"1:0:top\"]);
            break;
        case \"classic\":
            setPanelsEnabledList([\"1:0:top\", \"2:0:bottom\"]);
            break;
        case \"traditional\": /* Default (explicitly set) - no processing needed */
        default:
            break;
    }

    global.settings.reset(\"desktop-layout\");
}'''

new_func = '''function checkPanelUpgrade()
{
    global.settings.reset(\"desktop-layout\");
}'''

if old_func in content:
    content = content.replace(old_func, new_func)
    with open('$PANEL_JS', 'w') as f:
        f.write(content)
    print('Patched checkPanelUpgrade successfully')
else:
    print('Could not find checkPanelUpgrade - trying alternative approach')
    # Try to find just the function signature
    import re
    pattern = r'function checkPanelUpgrade\(\)\s*\{.*?global\.settings\.reset\(\"desktop-layout\"\);\s*\}'
    replacement = '''function checkPanelUpgrade()
{
    global.settings.reset(\"desktop-layout\");
}'''
    new_content, count = re.subn(pattern, replacement, content, flags=re.DOTALL)
    if count > 0:
        with open('$PANEL_JS', 'w') as f:
            f.write(new_content)
        print('Patched via regex successfully')
    else:
        print('FAILED to patch checkPanelUpgrade')
" 2>&1

echo "=== Step 3: Verify patch ==="
grep -n "checkPanelUpgrade" "$PANEL_JS" | head -5

echo "=== Step 4: Also patch appletManager to not auto-remove missing applets ==="
APPLET_MGR="$CHROOT/usr/share/cinnamon/js/ui/appletManager.js"
cp "$APPLET_MGR" "${APPLET_MGR}.bak"

echo "=== Step 5: Recompile gschema ==="
chroot "$CHROOT" glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>&1

echo "=== Step 6: Verify gsettings defaults ==="
chroot "$CHROOT" /bin/bash -c 'gsettings get org.cinnamon enabled-applets && gsettings get org.cinnamon panels-enabled' 2>&1

echo "=== DONE ==="
