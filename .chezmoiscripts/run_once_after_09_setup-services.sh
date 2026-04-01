#!/usr/bin/env bash
# Setup systemd services

for service in cronie mullvad-daemon fstrim.timer ufw; do
    echo "Setting up $service..."
    sudo systemctl enable "$service" --now
done

# System maintenance can run sudo w/o requesting. 
echo "Setting up sudoers file..."
SCRIPT_PATH="/home/$USER/.local/bin/sys-maintenance.sh"

sudo tee "/etc/sudoers.d/10-maintenance" <<EOF
$USER ALL=(ALL) NOPASSWD: $SCRIPT_PATH
$USER ALL=(ALL) NOPASSWD: $(whereis pacman | awk '{print $2}'), $(whereis paccache -r | awk '{print $2}'), $(whereis echo | awk '{print $2}') hyprland, $(whereis install | awk '{print $2}') -m644 -o 0 -g 0 *
EOF

sudo chmod 440 "/etc/sudoers.d/10-maintenance"

sudo tee "/etc/sudoers.d/15-mount-automation" <<EOF
$USER ALL=(ALL) NOPASSWD: $(whereis mount | awk '{print $2}'), $(whereis umount | awk '{print $2}'), $(whereis mkdir | awk '{print $2}'), $(whereis chown | awk '{print $2}'), $(whereis simple-mtpfs | awk '{print $2}')
EOF

# Set the correct permissions (required by sudo)
sudo chmod 440 "/etc/sudoers.d/15-mount-automation"

# Remove beep
rmmod pcspkr
echo "blacklist pcspkr" >/etc/modprobe.d/nobeep.conf

echo "Enabling maintenance timer..."
systemctl --user daemon-reload
systemctl --user enable --now maintenance.timer

echo "Setup complete. $USER can now run maintenance script without a password prompt."

# Setup Sycnthing as user
echo "Setting up Syncthing..."
systemctl --user enable syncthing.service --now
echo "Configuring Firewall (ufw)..."
# Syncthing uses 22000/TCP (transfer) and 21027/UDP (discovery)
if command -v ufw > /dev/null; then
    sudo ufw allow 22000/tcp
    sudo ufw allow 21027/udp
    sudo ufw reload
    echo "UFW rules updated."
else
    echo "UFW not found. If you use a different firewall, ensure ports 22000/tcp and 21027/udp are open."
fi

echo "Syncthing finished setting up. You can access the Web GUI at: http://127.0.0.1:8384"

# For timeshift
xhost +SI:localuser:root
