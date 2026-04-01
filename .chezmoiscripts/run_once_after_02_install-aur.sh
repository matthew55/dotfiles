#!/usr/bin/env bash

set -e

echo "Installing dependencies..."
sudo pacman -S --needed --noconfirm git base-devel

# Use all cores for compilation.
sed -i "s/-j2/-j$(nproc)/;/^#MAKEFLAGS/s/^#//" /etc/makepkg.conf

# Install yay if it is not installed
if ! command -v yay &> /dev/null; then
	echo "Installing yay..."

	cd /tmp
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm

	cd ..
	rm -rf yay
else
	echo "yay already installed"
fi

echo "Installing packages from AUR..."
yay -S --noconfirm --removemake zen-browser-bin \
	xwaylandvideobridge \
	wlogout \
	timeshift-autosnap \
	vesktop-bin \
	htop-vim \
	xdg-ninja \
	gtk-theme-windows10-dark \
	windows10-icon-theme \
	windows-10-cursor \
	rmg-bin \
	python-pywal16 \
	waypaper \
	nmrs \
	simple-mtpfs

echo "Done!"
