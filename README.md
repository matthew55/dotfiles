# Dotfiles
My important dotfiles hosted on GitHub, managed with [Chezmoi](https://www.chezmoi.io/).

https://github.com/user-attachments/assets/a9c443e1-90d6-46dc-ba5f-d1aee19d64b6

## What this does
* Installs a fully customized [Hyprland](https://hypr.land/) system with all my dotfiles
* Sets up system wide walpaper-dependent dynamic colorschemes for applications using [waypaper](https://github.com/anufrievroman/waypaper), [awww](https://codeberg.org/LGFae/awww), and [pywal16](https://github.com/eylles/pywal16)
* Configures custom themes for: [SDDM](https://github.com/Keyitdev/sddm-astronaut-theme), [Rofi](https://github.com/lr-tech/rofi-themes-collection), [Wlogout](https://github.com/DreamMaoMao/wlogout-theme/tree/main?tab=readme-ov-file), GTK, QT
* Installs plugins for [Hyprland](https://hypr.land/) and [Neovim](https://neovim.io/)
* Automatic snapshots through [Timeshift](https://github.com/linuxmint/timeshift) with BTRFS
* Installs Steam with GPU specific drivers
* Configure my personal SSH keys (not for you 😈) automatically
* And much, much more

## How to install? 
On a fresh bare metal (Arch Linux only) installation, preferrably with BTRF, run the following one liner:

```bash
sudo pacman -S --needed --noconfirm chezmoi && chezmoi init --apply matthew55
```

## How can I utilize [Chezmoi](https://www.chezmoi.io/) to manage my own dotfiles?
Check the [Chezmoi quick start](https://www.chezmoi.io/quick-start/). The syntax is almost a drop in substitution for git syntax and the documentation is great.
