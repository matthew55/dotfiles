#!/usr/bin/env bash
# Install Rofi themes

set -e

REPO_URL="https://github.com/lr-tech/rofi-themes-collection.git"
TEMP_DIR=$(mktemp -d)
ROFI_THEME_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/rofi/themes"

echo "Installing rofi and plugins..."
sudo pacman -S --needed --noconfirm rofi-wayland rofi-emoji papirus-icon-theme

mkdir -p "$ROFI_THEME_DIR"
if git clone --depth 1 "$REPO_URL" "$TEMP_DIR"; then
    cp -r "$TEMP_DIR/themes/"* "$ROFI_THEME_DIR/"
    echo "Themes installed successfully!"
else
    echo "Failed to clone the repository."
    exit 1
fi
rm -rf "$TEMP_DIR"

echo "Patching themes in $ROFI_THEME_DIR to be..."

for theme in "$ROFI_THEME_DIR"/*.rasi; do
    echo "Processing: $(basename "$theme")"
    sed -i 's/location\s*:\s*[^;]*/location: center/g' "$theme"
    sed -i 's/anchor\s*:\s*[^;]*/anchor: center/g' "$theme"
    sed -i 's/y-offset\s*:\s*[^;]*/y-offset: 0/g' "$theme"
    sed -i 's/x-offset\s*:\s*[^;]*/x-offset: 0/g' "$theme"
done

echo "Done! You can now select your theme in rofi using: rofi-theme-selector"
