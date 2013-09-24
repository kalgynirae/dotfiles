# Prompt
PS1='\[\e[1;30m\]\u@\h\[\e[0m\]:\[\e[1;30m\]\W\[\e[0m\]$(__git_ps1 " (%s)")\n'
PS1=$PS1'[\j]\$ '
export PS1

# Environment variables
PATH=$PATH:$HOME/dotfiles:$HOME/bin:$HOME/.gem/ruby/2.0.0/bin
HISTCONTROL=ignoreboth
HISTIGNORE="history:bg*:fg*:ls:ll:la:su"
HISTSIZE=2000
EDITOR=vim
export PATH HISTCONTROL HISTIGNORE HISTSIZE EDITOR

# Python environment variables
PYTHONSTARTUP=~/.pythonrc
PYTHONDONTWRITEBYTECODE=1
PYTHONPATH="/home/lumpy/python"
export PYTHONSTARTUP PYTHONDONTWRITEBYTECODE PYTHONPATH

# Aliases
alias su='su -'
alias ls='ls --color=always'
alias la='ls -AF'
alias ll='ls -hl'
alias tree='tree -CF --charset=utf-8'
alias diff='colordiff'
alias grep='grep -n --color=always'
alias less='less -RSXF'
alias qemu='qemu-system-x86_64 -enable-kvm'
alias lilypond='lilypond -dno-point-and-click'

# Disallow overwriting files by redirection with > (use >| instead)
set -o noclobber

# Fix the window size periodically, so resizing while in e.g. VIM doesn't break it
shopt -s checkwinsize

# Git completion and prompt string
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM='verbose'
source ~/.git-prompt.sh

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

open() {
    xdg-open "$1" >/dev/null 2>&1
}

if [[ -f ~/.localrc ]]; then
    source ~/.localrc
fi
