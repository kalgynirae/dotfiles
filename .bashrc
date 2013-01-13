# Prompt
PS1='\[\e[1;30m\]\u@\h\[\e[0m\]:\[\e[1;30m\]\W\[\e[0m\]$(__git_ps1 " (%s)")\n'
PS1=$PS1'[\j]\$ '
export PS1

# Environment variables
PATH=$PATH:$HOME/bin
HISTCONTROL=ignoreboth
HISTIGNORE="history*:bg*:fg*:ls:ll:la:cd ..:su:git status:git diff:git diff --cached:git log:startx:python:python2:python3:open *"
EDITOR=vim
export PATH HISTCONTROL HISTIGNORE EDITOR GOPATH

# Python environment variables
PYTHONSTARTUP=~/.pythonrc
PYTHONDONTWRITEBYTECODE=1
PYTHONPATH="/home/lumpy/python"
export PYTHONSTARTUP PYTHONDONTWRITEBYTECODE PYTHONPATH

# Aliases
alias su='su -'
alias open='xdg-open'
alias ls='ls --color=auto'
alias la='ls -AF'
alias ll='ls -hl'
alias tree='tree -C'
alias diff='colordiff'
alias grep='grep -n --color'
alias :q=exit

# Disallow overwriting files by redirection with > (use >| instead)
set -o noclobber

# Fix the window size periodically, so resizing while in e.g. VIM doesn't break it
shopt -s checkwinsize

# Git completion and prompt string
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM='verbose'
source ~/.git-completion.bash

# Complete partially-typed commands using the up/down arrow keys
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Colored man pages
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

mkcd() {
    mkdir -p "$1"
    cd "$1"
}
