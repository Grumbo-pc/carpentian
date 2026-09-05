#!/bin/bash
set -ex
CHROOT=/root/carpentian-build/chroot

echo "=== Current alternatives state ==="
chroot "$CHROOT" /bin/bash -c 'update-alternatives --query default.plymouth' 2>&1

echo "=== Simulating hook: THEME_PATH ==="
THEME_PATH=$(chroot "$CHROOT" /bin/bash -c 'update-alternatives --query default.plymouth 2>/dev/null' | sed -e '/^Value:/!d' -e 's/^Value: \(.*\)/\1/')
echo "THEME_PATH=$THEME_PATH"

THEME=$(basename "${THEME_PATH:-none}" .plymouth 2>/dev/null || true)
echo "THEME=$THEME"

THEMES="/usr/share/plymouth/themes"
echo "Theme file exists: $(ls "$CHROOT/$THEMES/$THEME/$THEME.plymouth" 2>&1)"

echo "=== IMAGE_PATH ==="
IMAGE_PATH=$(grep "ImageDir *= *" "$CHROOT/$THEME_PATH" 2>/dev/null | sed 's/ImageDir *= *//')
echo "IMAGE_PATH=$IMAGE_PATH"

echo "=== IMAGE_NAME ==="
if [ -n "${IMAGE_PATH}" ] && [ "${THEME_PATH}" != "${IMAGE_PATH}" ]; then
    IMAGE_NAME="$(basename ${IMAGE_PATH:-none})"
fi
echo "IMAGE_NAME=${IMAGE_NAME:-none}"

echo "=== PLUGIN_PATH ==="
PLUGIN_PATH=$(chroot "$CHROOT" /bin/bash -c 'plymouth --get-splash-plugin-path 2>/dev/null')
echo "PLUGIN_PATH=$PLUGIN_PATH"

echo "=== Module file ==="
MODULE_NAME=$(sed -n 's/^ModuleName=\(.*\)/\1/p' "$CHROOT/$THEMES/$THEME/$THEME.plymouth" 2>/dev/null)
echo "MODULE_NAME=$MODULE_NAME"
echo "Module exists: $(ls "$CHROOT/$PLUGIN_PATH/$MODULE_NAME.so" 2>&1)"

echo "=== TEXTTHEME ==="
TEXTTHEME_PATH=$(chroot "$CHROOT" /bin/bash -c 'update-alternatives --query text.plymouth 2>/dev/null' | sed -e '/^Value:/!d' -e 's/^Value: \(.*\)/\1/')
echo "TEXTTHEME_PATH=$TEXTTHEME_PATH"
TEXTTHEME=$(basename "${TEXTTHEME_PATH:-none}" .plymouth 2>/dev/null || true)
echo "TEXTTHEME=$TEXTTHEME"

echo "=== Test: does hook text theme check fail? ==="
# This is the buggy line: single & instead of &&
if [ -n "${TEXTTHEME}" ] & [ "${TEXTTHEME}" != "none" ]; then
    echo "text theme branch would execute"
else
    echo "text theme branch would NOT execute"
fi

echo "=== DONE ==="
