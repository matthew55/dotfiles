#!/bin/bash
# Setup TLDR

echo "Installing and setting up tealdeer..."
sudo pacman -S --needed --noconfirm tealdeer

# tealdeer requires an initial manual update to populate the cache
tldr --update

echo "Done! You can now use 'tldr <command>'."
