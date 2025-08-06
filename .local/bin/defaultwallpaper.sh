#!/bin/bash
IMAGE="$HOME/Pictures/desktop-backgrounds/luke-smith-background.png"
feh --no-fehbg --bg-fill "$IMAGE" 
wal -i "$IMAGE" -nq -o "$HOME/.config/wal/postrun"
