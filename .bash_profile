#
# ~/.bash_profile
#

#[[ -f ~/.bashrc ]] && . ~/.bashrng daemon.

if [ -n "$DESKTOP_SESSION" ];then
    eval $(/usr/bin/gnome-keyring-daemon --start, --components=gpg,pkcs11,secrets,ssh)
    export GPG_AGENT_INFO GNOME_KEYRING_CONTROL GNOME_KEYRING_PID SSH_AUTH_SOCK 
fi

# Get proper colors.
export TERM="xterm-256color"
# Set default text editor.
export EDITOR="vim"
# Set default terminal.
export TERMINAL="st"
# Set default browser.
export BROWSER="firefox"
# Fix window-frames in vieb browser.
export VIEB_WINDOW_FRAME="true"
# Fix white screen of death in Java AWT programs.
export _JAVA_AWT_WM_NONREPARENTING=1
# Prevent ranger from loading default config.
export RANGER_LOAD_DEFAULT_RC="false"
# Qt5ct environmental variable
export QT_QPA_PLATFORMTHEME="gt5ct"
export MOZ_WEBRENDER=1

export PATH="$PATH:/$HOME/.local/bin"
export PATH="$PATH:/$HOME/.local/bin/statusbar"
export PATH="$PATH:/$HOME/.local/bin/dmenu-scripts/"

# Auto start xorg on login.
if [[ "$(tty)" = "/dev/tty1" ]]; then
    startx
fi

