[[ $- == *i* ]] || return
HISTCONTROL=ignoreboth
HISTFILE=~/.bash_history_actual
HISTFILESIZE=-1
HISTIGNORE="history:bg*:d:dls:fg*:ls:ll:la:su"
HISTSIZE=-1
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
shopt -s histappend

alias commas='paste -sd,'
alias cp='cp -i'
alias diff='diff --color --minimal --unified'
alias f1='field 1'
alias f2='field 2'
alias f3='field 3'
alias f4='field 4'
alias f5='field 5'
alias grep='grep --color'
alias iotop='sudo iotop --delay 2'
alias la='ls --almost-all --classify'
alias lilypond='lilypond -dno-point-and-click --loglevel=PROGRESS'
alias lines='xargs printf "%s\n"'
alias ll='ls -l --human-readable'
alias ls='ls --color'
alias mplayer='mplayer -softvol -softvol-max 300'
alias mv='mv -i'
alias python='python2'
alias quotes="sed \"s/^/'/; s/$/'/\""
alias rm='rm --one-file-system'
alias ssh='ssh-with-terminfo'
alias ssh-patient='ssh -o ConnectTimeout=60 -o ServerAliveCountMax=6 -o ServerAliveInterval=10'
alias tree='tree -CF --charset=utf-8'
alias uncommas="tr , '\n'"
which nvim &>/dev/null && alias vim=nvim

# Disallow overwriting files by redirection with > (use >| instead)
set -o noclobber

# Disable C-s/C-q pausing and resuming output
stty -ixon

# Complete partially-typed commands using ctrl+p/n
bind '"\C-p":history-search-backward'
bind '"\C-n":history-search-forward'

cal() {
    local year=$(date +%Y)
    if (( $# == 0 )); then
        command cal "$year"
    elif (( $# == 1 && 1 <= $1 && $1 < 13 )); then
        command cal "$1" "$year"
    else
        command cal "$@"
    fi
}

# Test the terminal's text/color capabilities
colortest() {
    echo "NORMAL bold     dim      italic   underline BRIGHT bold     dim      italic   underline"
    for color in $(seq 0 7); do
        for intensity in 3 9; do  # normal, bright
            for style in "" $(seq 4); do  # normal, bold, dim, italic, underline
                escapes="[${intensity}${color}${style:+;$style}m"
                echo -en "\e${escapes}\\\\e${escapes}\e[0m "
            done
            echo -n " "
        done
        echo
    done
    echo -n "TRUECOLOR "
    awk 'BEGIN{
        columns = 78;
        step = columns / 6;
        for (hue = 0; hue<columns; hue++) {
            x = (hue % step) * 255 / step;
            if (hue < step) {
                r = 255; g = x; b = 0;
            } else if (hue < step*2) {
                r = 255-x; g = 255; b = 0;
            } else if (hue < step*3) {
                r = 0; g = 255; b = x;
            } else if (hue < step*4) {
                r = 0; g = 255-x; b = 255;
            } else if (hue < step*5) {
                r = x; g = 0; b = 255;
            } else {
                r = 255; g = 0; b = 255-x;
            }
            printf "\033[48;2;%d;%d;%dm", r, g, b;
            printf "\033[38;2;%d;%d;%dm", 255-r, 255-g, 255-b;
            printf " \033[0m";
        }
        printf "\n";
    }'
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
    tempdir=$(mktemp -d "/tmp/$name.dXXX") || return
    cd "$tempdir" && rename-tmux-window "$name"
}

# List existing temporary directories and their contents
dls() {
    for dir in /tmp/*.d???; do
        echo -n "$dir ("
        ls -m "$dir" |& tr , ' ' | tr -d '\n' | sed -E 's/(.{50}).+/\1…/'
        echo ')'
    done
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

# Extract the corresponding whitespace-separated fields
field() {
    awk "{print $(printf '$%s\n' "$@" | paste -sd,)}"
}

# Highlight occurrences of the given strings
hl() {
    grep -E --color=always "$(printf '%s|' "$@")"
}

# Extract the corresponding lines
line() {
    sed -n "$(printf '%sp\n' "$@" | paste -sd';')"
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

_tmux-complete() {
    if (( $COMP_KEY == 9 )); then
        # Invoked by Tab key; do nothing
        return
    fi
    local word_regex_escaped=$(sed 's/[.^$*+?()[{\|]/\\&/g' <<<"$2")
    local regex="\<$word_regex_escaped[[:alnum:]_/.-]+\>"
    COMPREPLY=($(tmux capture-pane -Jp | sed '/^\s*$/d' | grep -Eo "$regex"))
}
complete -o bashdefault -o default -D -F _tmux-complete

if [[ -f ~/.git-prompt.sh ]]; then
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUPSTREAM='verbose'
    source ~/.git-prompt.sh
    git_ps1='$(__git_ps1 " (%s)")'
fi

in-git-repo() {
    git rev-parse --is-inside-work-tree &>/dev/null
}

_not-yet() {
    echo >&2 "not implemented yet"
    return 1
}

amend() {
    if in-git-repo; then git commit --amend --no-edit "$@"; else _not-yet; fi
}

blame() {
    if in-git-repo; then git blame "$@"; else _not-yet; fi
}

del() {
    _not-yet
}

edit() {
    if in-git-repo; then git edit "$@"; else _not-yet; fi
}

ex() {
    if in-git-repo; then git show "$@"; else _not-yet; fi
}

lg() {
    if in-git-repo; then git graph "$@"; else _not-yet; fi
}

start() {
    if in-git-repo; then
        _not-yet
    else
        hg pull && _not-yet
    fi
}

up() {
    if in-git-repo; then git checkout "$@"; else hg update "$@"; fi
}

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
PS1="▶▶▶ ${color}\u@\h${reset}:${color}\W${reset}${git_ps1}\n[\j]\\\$ "
