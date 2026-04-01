#!/usr/bin/env bash
# Setup dirs required by programs

set -e

echo "Generating XDG user directories..."
xdg-user-dirs-update

echo "Setting up history files..."
mkdir -p "$XDG_STATE_HOME/bash/"
touch "$XDG_STATE_HOME/bash/history"

touch "$XDG_CONFIG_HOME/zsh/history"
echo "Done!"
