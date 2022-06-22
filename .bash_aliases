#!bin/bash

# Usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;; *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

alias ls="ls -AF --color=auto" \
    myip="curl -w \"\n\" ipinfo.io/ip" \
    pacman="pacman --color=auto" \
    yay="yay --color=auto" \
    maven="mvn" \
    gradle.bat="gradle" \
    gradlew="gradle" \
    gradlew.bat="gradle" \
    lastpass="lpass" \
    xclip="xclip -selection clipboard" \
    searchsploit="/opt/exploit-database/searchsploit" \
    ..="cd .." \
    rr="curl -s -L http://bit.ly/10hA8iC | bash" \
    mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist-arch" \
    mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist-arch" \
    mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist-arch" \
    mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist-arch" \
    fullmirror="/usr/bin/update-artix" \
    cleanup="sudo pacman -Rns $(pacman -Qtdq)" \
    grep="grep --color=auto" \
    gits="git status" \
    gitc="git commit" \
    gitp="git push" \
    hacker="cmatrix -a -u 3" \
    config="git --git-dir=$HOME/Desktop/coding-stuff/github/matthew55/dotfiles/ --work-tree=$HOME" \
