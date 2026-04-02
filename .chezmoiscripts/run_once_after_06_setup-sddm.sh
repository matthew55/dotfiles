#!/usr/bin/env bash
# Setup display manager with themes (requires manual input becaues I can't be bothered to automate an automated installation currently).

echo "Installing SDDM & tools for themes..."
sudo pacman -S --needed --noconfirm \
	sddm \
	qt6-declarative \
	qt5-declarative
echo "SDDM & tools installed."

echo "Running SDDM custom theme setup script (manual input requrired)..."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
echo "Custom SDDM theme setup complete."

echo "Enabling numlock on startup..."
echo -e "[General]\nNumlock=on" | sudo tee /etc/sddm.conf.d/numlock.conf > /dev/null
echo "Numlock setup on startup."

echo "Starting SDDM service..."
sudo systemctl enable sddm.service
echo "SDDM service started."
