#!/usr/bin/env bash
# Setup dirs required by programs

set -e

echo "Generating XDG user directories..."
xdg-user-dirs-update

echo "Setting up history files..."
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/bash/"
touch "${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"

touch "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/history"
echo "Done!"
