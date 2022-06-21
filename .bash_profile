#
# ~/.bash_profile
#

#[[ -f ~/.bashrc ]] && . ~/.bashrng daemon.

if [ -n "$DESKTOP_SESSION" ];then
    eval $(/usr/bin/gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

# Get proper colors.
export TERM="xterm-256color"
# Set default text editor.
export EDITOR="vim"
# Set default terminal.
export TERMINAL="st"
export TERMCMD="st"
# Set default browser.
export BROWSER="firefox"
# Fix window-frames in vieb browser.
export VIEB_WINDOW_FRAME=true
# Fix white screen of death in Java AWT programs.
export _JAVA_AWT_WM_NONREPARENTING=1
# Prevent ranger from loading default config.
export RANGER_LOAD_DEFAULT_RC=false
# Qt5ct environmental variable
export QT_QPA_PLATFORMTHEME=qt5ct

export PATH="$PATH:/$HOME/.local/bin"
export PATH="$PATH:/$HOME/.local/bin/statusbar"
export PATH="$PATH:/$HOME/.local/bin/dmenu-scripts/"

# Auto start xorg on login.
if [[ "$(tty)" = "/dev/tty1" ]]; then
    startx
fi

