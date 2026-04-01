#!/usr/bin/env bash

# --- 1. PRE-MAINTENANCE ---
notify-send "System Maintenance" "Starting scheduled updates..." -i system-software-update

# Update keyring
sudo pacman -Sy archlinux-keyring --noconfirm

# --- 2. UPDATES ---
# yay and hyprpm MUST run as the user
yay -Syu --noconfirm
hyprpm update

if command -v nvim &> /dev/null; then
    nvim --headless "+Lazy! sync" +qa
fi

# --- 3. CLEANUP ---
ORPHANS="$(yay -Qtdq || true)"
if [ -n "$ORPHANS" ]; then
    yay -Rns $ORPHANS --noconfirm
fi

sudo paccache -r
journalctl --vacuum-size=200M
rm -rf "$USER_HOME/.cache/mesa_shader_cache"

if command -v flatpak &> /dev/null; then
    flatpak uninstall --unused -y
fi

# --- 4. FINISH ---
FAILED_UNITS=$(systemctl --failed --no-legend | awk '{print $2}' | tr '\n' ' ')
[ -z "$FAILED_UNITS" ] && FAILED_UNITS="None"

notify-send "Maintenance Complete" "System is lean. \nFailed: $FAILED_UNITS" -i checkbox-checked-symbolic
