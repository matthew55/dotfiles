#
# ~/.zshrc
#

HISTFILE=~/.bash_history
HISTSIZE=1000
SAVEHIST=1000

# Run custom bash_aliase file to store aliases in one location.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable colors and change prompt:
autoload -U colors && colors  # Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd # Automatically cd into typed directory.
stty stop undef # Disable ctrl-s to freeze terminal.
setopt interactive_comments

# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files.

# Bash insulter
if [ -f /etc/bash.command-not-found ]; then
    . /etc/bash.command-not-found
fi

# Enable VI mode.
bindkey -v
# Make backspace & delete work as you would expect them to.
bindkey "^?" backward-delete-char
bindkey "^[[P" delete-char
bindkey "^H" backward-kill-word
bindkey "^[[M" kill-word
# Set key delay to 10ms.
KEYTIMEOUT=1
# Change cursor shape for different VI modes.
zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
# Start in instert mode.
zle-line-init() {
    echo -ne "\e[5 q"
}
# Default to normal mode when exiting. (Fixes Vim cursor, etc..)
zle-line-finish() {
    echo -ne "\e[1 q"
}
zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

# Use VI keybinds for tab completion.
zstyle ':completion:*' menu select
zmodload zsh/complist

# use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Setup thefuck alias.
eval "$(thefuck --alias)"

# Load syntax highlighting.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh 2>/dev/null

