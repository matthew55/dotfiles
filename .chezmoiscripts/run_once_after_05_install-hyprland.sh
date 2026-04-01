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
	g++ \
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
	nwg-displays:waybar
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

echo "Installing hyprpm plugins..."
# Ask for the administrator password upfront so we can use the yes command
sudo -v
# Keep-alive: update existing sudo time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

hyprpm update
yes | hyprpm add https://github.com/hyprwm/hyprland-plugins
yes | hyprpm add https://github.com/Duckonaut/split-monitor-workspaces
yes | hyprpm add https://github.com/hyprnux/hyprglass
yes | hyprpm add https://github.com/raybbian/hyprtasking
hyprpm enable csgo-vulkan-fix
hyprpm enable split-monitor-workspaces
hyprpm enable hyprglass
hyprpm enable hyprtasking
# Reload Hyprland to apply plugin changes
hyprctl reload
echo "Done! Hyprpm plugins installed."
echo ""
echo "To start Hyprland manually run:"
echo "start-hyprland"
echo ""

