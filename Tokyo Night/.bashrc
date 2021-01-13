#############################################
#           _    _____ _________            #
#          | |  |  _  \  _   _  |           #
#          | |  | | | | | | | | |           #
#          | |  | | | | | | | | |           #
#          | |__| |_| | | | | | |           #
#          |____|____/|_| |_| |_|           #
#                                           #
#   site: https://link-does-mods.github.io/ #
# github: https://github.com/link-does-mods #
#############################################

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HISTCONTROL=ignoreboth:erasedups

PS1='[\u@\h \W]\$ '

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

# Powerline shell prompt
function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# Ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

# List
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -la'
alias l='ls'
alias l.="ls -A | egrep '^\.'"

# Pacman
alias pacinstall='sudo pacman -S'
alias pacremove='sudo pacman -Rcns'
alias pacupdate='sudo pacman -Syy'
alias pacupgrade='sudo pacman -Syu --noconfirm && xmonad --restart'

# Alsamixer
alias alsa='alsamixer'

# Git
alias git='git clone'

# Confirm when modifying files
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Run neovim like vim
alias vim='nvim'

# Shopt
shopt -s autocd # Change to named directory
shopt -s cdspell # Autocorrects cd misspellings
shopt -s cmdhist # Save multi-line commands in history as single line
shopt -s dotglob
shopt -s histappend # Do not overwrite history
shopt -s expand_aliases # Expand aliases

# Youtube-dl
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "

alias ytv-best="youtube-dl -f bestvideo+bestaudio "

# Recent Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

# iso and version used to install ArcoLinux
alias iso="cat /etc/dev-rel | awk -F '=' '/ISO/ {print $2}'"

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
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
