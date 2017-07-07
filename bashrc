[[ $- == *i* ]] || return
HISTCONTROL=ignoreboth
HISTIGNORE="history:bg*:fg*:ls:ll:la:su"
HISTSIZE=-1
HISTFILESIZE=10000
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
shopt -s histappend

if [[ -n $TMUX ]]; then
    case $(tmux showenv TERM 2>/dev/null) in
        *256color) export TERM=screen-256color ;;
    esac
fi

alias commas='paste -sd,'
alias cp='cp -i'
alias diff='diff --color --minimal --unified'
alias grep='grep --color'
alias iotop='sudo iotop --delay 2'
alias la='ls --almost-all --classify'
alias lilypond='lilypond -dno-point-and-click --loglevel=PROGRESS'
alias ll='ls -l --human-readable'
alias ls='ls --color'
alias mplayer='mplayer -softvol -softvol-max 300'
alias mv='mv -i'
alias python='python2'
alias quotes="sed \"s/^/'/; s/$/'/\""
alias rm='rm --one-file-system'
alias ssh-patient='ssh -o ConnectTimeout=60 -o ServerAliveCountMax=6 -o ServerAliveInterval=10'
alias tree='tree -CF --charset=utf-8'
which nvim &>/dev/null && alias vim=nvim

# Disallow overwriting files by redirection with > (use >| instead)
set -o noclobber

# Disable C-s/C-q pausing and resuming output
stty -ixon

# Complete partially-typed commands using up/down and ctrl+p/n
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
bind '"\C-p":history-search-backward'
bind '"\C-n":history-search-forward'

cal() {
    local year=$(date +%Y)
    if (( $# == 0 )); then
        command cal "$year"
    elif (( $# == 1 && 1 <= $1 && $1 < 133 )); then
        command cal "$1" "$year"
    else
        command cal "$@"
    fi
}

# Print each filename followed by its contents
fancycat() {
    for file in "$@"; do
        echo -e "\e[1;36m# $file\e[0m"
        cat "$file"
    done
}

fancyhead() {
    height=$(( ($(tput lines) - 2) / $# - 1 ))
    (( height < 1 )) && height=1
    for file in "$@"; do
        echo -e "\e[1;36m# $file\e[0m"
        head -n $height "$file"
    done
}

# Display man pages with color
man() {
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

mkcd() {
    mkdir -p "$1" && cd "$1"
}

open() {
    xdg-open "$1" &>/dev/null
}

rename-tmux-window() {
    [[ -n $TMUX ]] && tmux rename-window "$1"
}

# Create a temporary directory with a friendly name and cd to it
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

dls() {
    find /tmp -maxdepth 1 -type d -name '*.???'
}

# Extract the corresponding whitespace-separated fields
f() {
    awk "{print $(printf '$%s\n' "$@" | paste -sd,)}"
}

# Highlight occurrences of the given strings
hl() {
    grep -E --color=always "$(printf '%s|' "$@")$"
}

# Extract the corresponding lines
l() {
    sed -n "$(printf '%sp\n' "$@" | paste -sd';')"
}

# View a file with syntax highlighting
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
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUPSTREAM='verbose'
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
PS1="▶▶▶ ${color}\u@\h${reset}:${color}\W${reset}${git_ps1}\n[\j]\\$ "
