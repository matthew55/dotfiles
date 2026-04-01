#!/usr/bin/env bash

echo "Initializing Steam setup..."

# Enable multilib if not already enabled
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
    sudo pacman -Sy
fi

echo "Installing GPU specific packages..."
GPU_TYPE=$(lspci | grep -E "VGA|3D" | tr '[:upper:]' '[:lower:]')
PKGS="steam gamescope lib32-systemd" 

if [[ $GPU_TYPE == *"nvidia"* ]]; then
    echo "Nvidia GPU detected."
    PKGS+=" nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings"
elif [[ $GPU_TYPE == *"amd"* ]] || [[ $GPU_TYPE == *"ati"* ]]; then
    echo "AMD GPU detected."
    PKGS+=" xf86-video-amdgpu lib32-mesa vulkan-radeon lib32-vulkan-radeon"
elif [[ $GPU_TYPE == *"intel"* ]]; then
    echo "Intel GPU detected."
    PKGS+=" vulkan-intel lib32-vulkan-intel mesa lib32-mesa"
fi

sudo pacman -S --needed --noconfirm $PKGS

# Create wrapper script to force XDG_BASE_DIR standard
WRAPPER_DIR="$HOME/.local/bin"
STEAM_DATA_DIR="$HOME/.local/data/games/steam-garbage"
mkdir -p "$WRAPPER_DIR"
mkdir -p "$STEAM_DATA_DIR"

WRAPPER_PATH="$WRAPPER_DIR/steam-isolated"

echo "Creating the wrapper script at $WRAPPER_PATH..."

cat <<EOF > "$WRAPPER_PATH"
#!/usr/bin/env sh
HOME="$STEAM_DATA_DIR"
exec /usr/bin/steam "\$@"
EOF

chmod +x "$WRAPPER_PATH"

# Create custom .desktop entry for wrapper
DESKTOP_ENTRY="$HOME/.local/share/applications/steam-isolated.desktop"
mkdir -p "$(dirname "$DESKTOP_ENTRY")"

echo "Generating custom .desktop entry for wrapper..."

cat <<EOF > "$DESKTOP_ENTRY"
[Desktop Entry]
Name=Steam (Isolated)
Comment=Play games on Steam in a garbage-collected directory
Exec=$WRAPPER_PATH %U
Icon=steam
Terminal=false
Type=Application
Categories=Game;GTK;
MimeType=x-scheme-handler/steam;
EOF

# Sanity check to ensure wrapper is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Warning: $HOME/.local/bin is not in your PATH."
    echo "Add 'export PATH=\$HOME/.local/bin:\$PATH' to your .zshrc or .bashrc."
fi

echo "Done! You can now launch 'Steam (Isolated)' from your app launcher."
