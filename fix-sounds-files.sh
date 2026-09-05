#!/bin/bash
cd /root/carpentian-build/chroot/usr/share/sounds/Vicious/stereo

fixed=0
for f in *.oga; do
    [ -f "$f" ] || continue
    if ! head -c 4 "$f" | grep -q OggS; then
        target=$(cat "$f" | tr -d '\0')
        # normalize leading ./ if present
        target=${target#./}
        if [ -f "$target" ] || [ -L "$target" ]; then
            rm -f "$f"
            ln -s "$target" "$f"
            echo "FIXED $f -> $target"
            fixed=$((fixed+1))
        else
            echo "NO-TARGET $f -> $target"
        fi
    fi
done

echo "--- screen-capture.ogg special case ---"
rm -f screen-capture.ogg
ln -s complete.ogg screen-capture.ogg
echo "FIXED screen-capture.ogg -> complete.ogg"

echo "=== re-verify all files are Ogg or valid symlinks ==="
bad=0
for f in *; do
    if [ -L "$f" ] || [ -f "$f" ]; then
        if ! head -c 4 "$f" 2>/dev/null | grep -q OggS; then
            echo "STILL-BROKEN: $f (content: $(head -c 20 "$f" | tr -d '\0'))"
            bad=$((bad+1))
        fi
    fi
done
echo "total broken remaining: $bad"
echo "fixed count: $fixed"