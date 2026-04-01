#!/usr/bin/env bash
# Setup keyd to remap keys.

echo "Installing keyd to remap keys..."
sudo pacman -S --needed --noconfirm keyd

echo "Enabling keyd service..."
sudo systemctl enable keyd --now

echo "Writing simplified keyd config..."
sudo tee "/etc/keyd/default.conf" > /dev/null << 'EOF'
[ids]
*

[main]
# Swap physical Escape to act as Caps Lock
esc = capslock

# Caps Lock: Hold = Meta (Super/Windows), Tap = Escape
capslock = overloadt(meta, esc, 150)

# Ensure no other layer is interfering
[meta]
capslock = none
EOF

echo "Restarting and reloading keyd..."
sudo systemctl restart keyd
sudo keyd reload

echo "Done! Caps Lock and Escape have now swaped functions."
