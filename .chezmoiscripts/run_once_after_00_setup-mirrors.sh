#!/usr/bin/env bash
# Installs reflector and setup up a Systemd service to rank Pacman mirrors once a day.

echo "Installing Reflector..."
sudo pacman -S --needed --noconfirm reflector

# --latest 20: Looks at the 20 most recently synced mirrors globally
# --protocol https: Security first
# --sort rate: Specifically tests which one is fastest for the connection
echo "Configuring /etc/xdg/reflector/reflector.conf..."
sudo tee /etc/xdg/reflector/reflector.conf > /dev/null <<EOF
--save /etc/pacman.d/mirrorlist
--protocol https
--latest 20
--sort rate
EOF

# The default reflector.timer is weekly. This makes it daily.
echo "Setting timer to daily..."
sudo mkdir -p /etc/systemd/system/reflector.timer.d
sudo tee /etc/systemd/system/reflector.timer.d/override.conf > /dev/null <<EOF
[Timer]
OnCalendar=daily
Persistent=true
EOF

echo "Activating services..."
sudo systemctl daemon-reload
sudo systemctl enable --now reflector.timer

echo "Running initial mirror sync (this may take a minute)..."
sudo systemctl start reflector.service

echo "Done!"
