# Environment variables
export EDITOR=vim
export HISTCONTROL=ignoreboth
export HISTIGNORE="history:bg*:fg*:ls:ll:la:su"
export HISTSIZE=5000
export LESS='--chop-long-lines --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
export PATH=$PATH:$HOME/dotfiles:$HOME/bin:$HOME/.gem/ruby/2.0.0/bin
export PYTHONPATH=/home/lumpy/python
export PYTHONSTARTUP=~/.pythonrc

# Aliases
alias su='su --login'
alias ls='ls --color'
alias la='ls --almost-all --classify'
alias ll='ls -l --human-readable'
alias tree='tree -CF --charset=utf-8'
alias grep='grep --line-number --color'
alias lilypond='lilypond -dno-point-and-click --loglevel=PROGRESS'
alias python='python3'

# Disallow overwriting files by redirection with > (use >| instead)
set -o noclobber

# Fix the window size periodically, so resizing while in e.g. VIM doesn't break it
shopt -s checkwinsize
shopt -s histappend

# Complete partially-typed commands using the up/down arrow keys
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

diff() {
    colordiff "$@" | less
}

make() {
    colormake "$@" | less
}

man() { # Display man pages with color
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

# Prompt defaults (PS1 is actually set further down)
prompt_color='\[\e[1;30m\]'
prompt_reset='\[\e[0m\]'
prompt_user=$prompt_color'\u@\h'$prompt_reset
prompt_dir=$prompt_color'\W'$prompt_reset
prompt_git=

# Git completion and prompt string
if [[ -f ~/.git-prompt.sh ]]; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUPSTREAM='verbose'
    source ~/.git-prompt.sh
    prompt_git='$(__git_ps1 " (%s)")'
fi

# Source the localrc if there is one
if [[ -f ~/.localrc ]]; then
    source ~/.localrc
fi

export PS1=$prompt_user':'$prompt_dir$prompt_git'\n[\j]\$ '
