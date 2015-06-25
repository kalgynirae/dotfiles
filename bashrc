# Aliases
alias cp='cp -i'
alias grep='grep --color'
alias ls='ls --color'
alias la='ls --almost-all --classify'
alias ll='ls -l --human-readable'
alias tree='tree -CF --charset=utf-8'
alias lilypond='lilypond -dno-point-and-click --loglevel=PROGRESS'
alias mplayer='mplayer -softvol'
alias mv='mv -i'
alias rm='rm -I --one-file-system'
alias python='python2'

# Disallow overwriting files by redirection with > (use >| instead)
set -o noclobber

# Fix the window size periodically, so resizing while in e.g. VIM doesn't break it
shopt -s checkwinsize
shopt -s histappend

# Complete partially-typed commands using the up/down arrow keys
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
bind '"\C-p":history-search-backward'
bind '"\C-n":history-search-forward'

if ! type man | grep -q function; then
    man() { # Display man pages with color
        env \
            LESS_TERMCAP_mb=$(printf "\e[1;31m") \
            LESS_TERMCAP_md=$(printf "\e[1;32m") \
            LESS_TERMCAP_me=$(printf "\e[0m") \
            LESS_TERMCAP_se=$(printf "\e[0m") \
            LESS_TERMCAP_so=$(printf "\e[1;44;37m") \
            LESS_TERMCAP_ue=$(printf "\e[0m") \
            LESS_TERMCAP_us=$(printf "\e[1;33m") \
            man "$@"
    }
fi

mkcd() {
    mkdir -p "$1"
    cd "$1"
}

open() {
    xdg-open "$1" >/dev/null 2>&1
}

p() {
    pygmentize -g "$@" | less
}

if [[ -f ~/.git-prompt.sh ]]; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUPSTREAM='verbose'
    source ~/.git-prompt.sh
    git_ps1='$(__git_ps1 " (%s)")'
fi

_hashcolor() {
    hash=$(echo -n "$1" | md5sum)
    color=$(( 0x${hash:0:8} % 6 + 1 ))
    style=$(( 0x${hash:8:8} % 5 ))
    echo -E "\e[${style};3${color}m"
}

color='$(echo -e $(_hashcolor "$(whoami)@$(hostname):$(pwd -P)"))'
reset='\[\e[0m\]'
export PS1="${color}\u@\h${reset}:${color}\W${reset}${git_ps1}\n[\j]\$ "
