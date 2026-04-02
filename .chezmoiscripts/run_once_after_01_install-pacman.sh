#!/usr/bin/env bash
# 5. Run it once immediately to get your first fast list

FILE="/etc/pacman.conf"

echo "Updating $FILE for maximum aesthetics..."

# 1. Enable Color (removes the '#' from '#Color')
sudo sed -i 's/^#Color/Color/' "$FILE"

# 2. Enable Parallel Downloads (optional but recommended, set to 5)
sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 5/' "$FILE"

# 3. Add 'ILoveCandy' if it doesn't exist
if ! grep -q "ILoveCandy" "$FILE"; then
    # Inserts 'ILoveCandy' on the line immediately following 'Color'
    sudo sed -i '/^Color/a ILoveCandy' "$FILE"
    echo "ILoveCandy enabled!"
fi

echo "Pacman is now colorful and hungry."

echo "Installing packages from pacman..."
sudo pacman -S --needed --noconfirm \
	pacman-contrib \
	xdg-user-dirs \
	thunar \
	wtype \
	brightnessctl \
	pamixer \
	cliphist \
	wl-clip-persist \
	qt5-wayland \
	qt6-wayland \
	less \
	man \
	hyprpicker \
	udiskie \
	fastfetch \
	neovim \
	mpv \
	yt-dlp \
	glow \
	ripgrep \
	unzip \
	nodejs \
	npm \
	base-devel \
	clang \
	jdk-openjdk \
	shellcheck \
	python-pip \
	evince \
	satty \
	qt5ct \
	qt6ct \
	kvantum \
	kvantum-qt5 \
	imv \
	imagemagick \
	gimp \
	gutenprint \
	foomatic-db-gutenprint-ppds \
	timeshift \
	syncthing \
	mullvad-vpn \
	cronie \
	xorg-xhost \
	joyutils \
	wine \
	openbsd-netcat \
	keepassxc \
	python-httplib2 \
	fzf \
	fd \
	bat \
	zsh-autosuggestions \
	zsh-syntax-highlighting \
	gnome-keyring \
	rustup \
	bluetui \
	ffmpegthumbnailer \
	tumbler \
	chezmoi \
	wget \
	arch-wiki-docs \
	ufw

echo "Done!"
