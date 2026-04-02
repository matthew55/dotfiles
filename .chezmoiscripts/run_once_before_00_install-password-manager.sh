#!/usr/bin/env bash

# Exit immedietly if needed binaries are already in PATH.
(type age >/dev/null 2>&1 && type keepassxc-cli >/dev/null 2>&1) && exit

echo "Installing required dependencies for chezmoi setup..."
sudo pacman -S --needed --noconfirm age git keepassxc
echo "Done!"
