[[ $- == *i* ]] || return
export HISTCONTROL=ignoreboth
export HISTIGNORE="history:bg*:fg*:ls:ll:la:su"
export HISTSIZE=-1
export HISTFILESIZE=10000
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

alias cp='cp -i'
alias grep='grep --color'
alias la='ls --almost-all --classify'
alias lilypond='lilypond -dno-point-and-click --loglevel=PROGRESS'
alias ll='ls -l --human-readable'
alias ls='ls --color'
alias mpc='mpc --host=fruitron'
alias mplayer='mplayer -softvol -softvol-max 300'
alias mv='mv -i'
alias python='python2'
alias rm='rm --one-file-system'
alias ssh-patient='ssh -o ConnectTimeout=60 -o ServerAliveCountMax=6 -o ServerAliveInterval=10'
alias tree='tree -CF --charset=utf-8'

# Disallow overwriting files by redirection with > (use >| instead)
set -o noclobber

shopt -s histappend

# Disable C-s/C-q pausing and resuming output
stty -ixon

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

rename-tmux-window() {
    [[ -n $TMUX ]] && tmux rename-window "$1"
}

d() {
    local name
    if (( $# )); then
        name=$1
    else
        while true; do
            name=$(shuf -n1 ~/dotfiles/bip39-english.txt) || return
            # Skip names that are commands to avoid any confusion
            type "$name" &>/dev/null && continue
            # Skip names for which /tmp/$name.* already exists
            compgen -G "/tmp/$name.*" && continue
            break
        done
    fi
    local tempdir
    tempdir=$(mktemp -d "/tmp/$name.XXX") || return
    cd "$tempdir" && rename-tmux-window "$name"
}

p() {
    pygmentize -g "$@" | less
}

_tmux_complete() {
    if (( $COMP_KEY == 9 )); then
        # Invoked by Tab key; do nothing
        return
    fi
    local word_regex_escaped=$(sed 's/[.^$*+?()[{\|]/\\&/g' <<<"$2")
    local regex="\<$word_regex_escaped[[:alnum:]_/.-]+\>"
    COMPREPLY=($(tmux capture-pane -Jp | sed '/^\s*$/d' | grep -Eo "$regex"))
}
complete -o bashdefault -o default -D -F _tmux_complete

if [[ -f ~/.git-prompt.sh ]]; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUPSTREAM='verbose'
    source ~/.git-prompt.sh
    git_ps1='$(__git_ps1 " (%s)")'
fi

_prompt_colors=(0 1 2 3 4 5 6)
_prompt_styles=(0 1 3 4)
_hashcolor() {
    local hash=$(echo -n "$1" | md5sum)
    local color_index=$(( 0x${hash:0:8} % ${#_prompt_colors[@]} ))
    local style_index=$(( 0x${hash:8:8} % ${#_prompt_styles[@]} ))
    local color=${_prompt_colors[color_index]}
    local style=${_prompt_styles[style_index]}
    if (( color == 0 && style == 0 )); then
        color=2
        style=4
    fi
    echo -E "\e[${style};3${color}m"
}

color='$(echo -e $(_hashcolor "$(whoami)@$(hostname):$(pwd -P)"))'
reset='\[\e[0m\]'
export PS1="▶▶▶ ${color}\u@\h${reset}:${color}\W${reset}${git_ps1}\n[\j]\\$ "
