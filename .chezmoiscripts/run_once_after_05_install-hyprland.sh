#!/usr/bin/env bash

echo "Upgrading system..."
sudo pacman -Syu --noconfirm

echo "Installing Hyprland and core Wayland utilities..."
sudo pacman -S --needed --noconfirm \
	hyprland \
	waybar \
	hyprlock \
	mako \
	kitty \
	wl-clipboard \
	grim \
	slurp \
	swww \
	dconf \
	base-devel \
	cmake \
	cpio \
	git \
	gcc \
	pkg-config \
	jq \
	meson \
	pacman-contrib \
	gsettings-desktop-schemas \
	xdg-desktop-portal \
	xdg-desktop-portal-hyprland \
	xdg-desktop-portal-gtk \
	polkit-kde-agent \
	network-manager-applet \
	nwg-displays \
	handlr-regex \
	ttf-dejavu \
	ttf-liberation \
	noto-fonts \
	noto-fonts-cjk \
	noto-fonts-emoji \
	noto-fonts-extra \
	ttf-jetbrains-mono-nerd \
	ttf-ibm-plex \
	ttf-nerd-fonts-symbols 

echo "==================================================="
echo "           Installing hyprpm plugins..."
echo "     (This will launch hyprland for a second)"
echo "(Don't touch anything, it will close automatically)"
echo "==================================================="
# Ask for the administrator password upfront and keep alive until no longer needed
sudo -v
while true; do 
    sudo -n v; 
    sleep 60; 
    kill -0 "$$" || exit; 
done 2>/dev/null &
SUDO_LOOP_PID=$!

# Hyprland must unfortunately be running to install plugins, and there is no headless mode yet.
# This is a shit solution and maybe one day this will be able to be properly implemented.
start-hyprland >/dev/null 2>&1 &
HYPR_PID=$!
sleep 2

hyprpm update
yes | hyprpm add https://github.com/hyprwm/hyprland-plugins
yes | hyprpm add https://github.com/Duckonaut/split-monitor-workspaces
yes | hyprpm add https://github.com/hyprnux/hyprglass
yes | hyprpm add https://github.com/raybbian/hyprtasking
hyprpm enable csgo-vulkan-fix
hyprpm enable split-monitor-workspaces
hyprpm enable hyprglass
hyprpm enable hyprtasking

hyprctl reload

kill $HYPR_PID
kill $SUDO_LOOP_PID

echo "Done! Hyprpm plugins installed."
echo ""
echo "To start Hyprland manually run:"
echo "start-hyprland"
echo ""

