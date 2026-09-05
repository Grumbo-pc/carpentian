#!/bin/bash
# Carpentian OS Theme Test Script
# This script tests if all theme components are properly installed

echo "=========================================="
echo "  Carpentian OS Theme Test"
echo "=========================================="

# Test function
test_component() {
    local name="$1"
    local path="$2"
    
    if [ -e "$path" ]; then
        echo "✓ $name: Installed"
        return 0
    else
        echo "✗ $name: NOT FOUND"
        return 1
    fi
}

# Initialize test results
total=0
passed=0

echo ""
echo "Testing theme components..."
echo ""

# Test icon theme
test_component "Icon Theme" "/usr/share/icons/Carpentian-Gnome"
((total++))
if [ $? -eq 0 ]; then ((passed++)); fi

# Test cursor theme
test_component "Cursor Theme" "/usr/share/icons/Carpentian-cursors"
((total++))
if [ $? -eq 0 ]; then ((passed++)); fi

# Test sound theme
test_component "Sound Theme" "/usr/share/sounds/Vicious"
((total++))
if [ $? -eq 0 ]; then ((passed++)); fi

# Test GTK theme
test_component "GTK Theme" "/usr/share/themes/Carpentian-Win9x"
((total++))
if [ $? -eq 0 ]; then ((passed++)); fi

# Test wallpapers
test_component "Wallpapers" "/usr/share/backgrounds/carpentian"
((total++))
if [ $? -eq 0 ]; then ((passed++)); fi

# Test neofetch config
test_component "Neofetch Config" "/etc/neofetch/config.conf"
((total++))
if [ $? -eq 0 ]; then ((passed++)); fi

# Test custom neofetch art
test_component "Custom Neofetch Art" "/usr/share/neofetch/ascii/sc"
((total++))
if [ $? -eq 0 ]; then ((passed++)); fi

echo ""
echo "=========================================="
echo "  Test Results: $passed/$total components installed"
echo "=========================================="

# Test GNOME settings
echo ""
echo "Testing GNOME settings..."
echo ""

# Function to test gsettings
test_gsetting() {
    local setting="$1"
    local expected="$2"
    local description="$3"
    
    local actual=$(gsettings get $setting 2>/dev/null)
    if [ "$actual" = "$expected" ]; then
        echo "✓ $description: Correct"
        return 0
    else
        echo "✗ $description: Incorrect (expected $expected, got $actual)"
        return 1
    fi
}

# Test dock position
test_gsetting "org.gnome.shell.extensions.dash-to-dock dock-position" "'BOTTOM'" "Dock Position"
((total++))
if [ $? -eq 0 ]; then ((passed++)); fi

# Test icon theme setting
test_gsetting "org.gnome.desktop.interface icon-theme" "'Carpentian-Gnome'" "Icon Theme Setting"
((total++))
if [ $? -eq 0 ]; then ((passed++)); fi

# Test cursor theme setting
test_gsetting "org.gnome.desktop.interface cursor-theme" "'Carpentian-cursors'" "Cursor Theme Setting"
((total++))
if [ $? -eq 0 ]; then ((passed++)); fi

# Test sound theme setting
test_gsetting "org.gnome.desktop.interface sound-theme" "'Vicious'" "Sound Theme Setting"
((total++))
if [ $? -eq 0 ]; then ((passed++)); fi

# Test GTK theme setting
test_gsetting "org.gnome.desktop.interface gtk-theme" "'Carpentian-Win9x'" "GTK Theme Setting"
((total++))
if [ $? -eq 0 ]; then ((passed++)); fi

echo ""
echo "=========================================="
echo "  Final Results: $passed/$total tests passed"
echo "=========================================="

if [ $passed -eq $total ]; then
    echo ""
    echo "All tests passed! Carpentian OS theme is properly installed."
    echo ""
    echo "To see the neofetch art, run:"
    echo "  neofetch"
    echo ""
    echo "To apply changes, log out and back in, or run:"
    echo "  gnome-session-quit --logout --no-prompt"
else
    echo ""
    echo "Some tests failed. Please run the setup script again:"
    echo "  ./setup-carpentian-wsl.sh"
fi
