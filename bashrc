#!/bin/bash
[[ $- != *i* ]] && return

HISTCONTROL=ignoreboth
HISTFILE=~/.bash_history_actual
HISTFILESIZE=-1
HISTIGNORE="history:bg*:d:dls:e:fg*:ls:ll:la:su:ytd"
HISTSIZE=-1
shopt -s histappend
set +H

export COLORTERM=truecolor
export LESS='-SR --ignore-case --mouse --no-init --quit-if-one-screen --wheel-lines=5'
export PYTHONDONTWRITEBYTECODE=yes
export PYTHONSTARTUP=$HOME/.pythonrc
export RSYNC_PROTECT_ARGS=1

# Work around Kitty preventing my customized terminfo from being read
if [[ $TERMINFO = */kitty/terminfo ]]; then
  unset TERMINFO
fi

alias commas='paste -sd,'
alias diff='diff --color=always --minimal --unified'
alias dnf='dnf --cacheonly'
[[ $HOSTNAME == colinchan-fedora-* ]] && alias et='et -p 8080'
alias f1='field 1'
alias f2='field 2'
alias f3='field 3'
alias f4='field 4'
alias f5='field 5'
alias grep='grep --color'
alias iotop='sudo iotop --delay 2'
alias jc=journalctl
alias jcu='journalctl --user'
alias l=less
alias la='ls --almost-all --classify'
alias lilypond='lilypond -dno-point-and-click --loglevel=PROGRESS'
alias lines='xargs printf "%s\n"'
alias ll='ls -l --human-readable'
alias lolcat='lolcat -ft'
alias ls='ls --color'
alias now='date +%s'
alias parallel='parallel --will-cite'
alias py=ipython3
alias python=python2
alias quotes="sed \"s/^/'/; s/$/'/\""
alias rm='rm --one-file-system'
alias sc=systemctl
alias scu='systemctl --user'
alias ssh='ssh-with-terminfo'
alias ssh-patient='ssh -o ConnectTimeout=60 -o ServerAliveCountMax=6 -o ServerAliveInterval=10'
alias tree='tree -CF --charset=utf-8'
alias uncommas="tr , '\n'"

# Disable C-s/C-q pausing and resuming output
stty -ixon

_prompt_command() {
  history -a
  if [[ $TMUX ]]; then
    eval "$(tmux showenv -s DARK_THEME)"
  fi
}
PROMPT_COMMAND="_prompt_command${PROMPT_COMMAND:+"; $PROMPT_COMMAND"}"

cal() {
  local year
  year=$(date +%Y)
  if (( $# == 0 )); then
    command cal "$year"
  elif (( $# == 1 && 1 <= $1 && $1 < 13 )); then
    command cal "$1" "$year"
  else
    command cal "$@"
  fi
}

# If inside of neovide-terminal
cd() {
  if [[ $CD_IN_NVIM ]] && (( $# <= 1 )); then
    nvr -c "cd $1"
  fi
  command cd "$@"
}

# Test the terminal's text/color capabilities
colortest() {
  local color escapes intensity style
  echo "NORMAL bold  dim   itali under rever strik  BRIGHT bold  dim   itali under rever strik"
  for color in $(seq 0 7); do
    for intensity in 3 9; do  # normal, bright
      escapes="${intensity}${color}"
      printf '\e[%sm\\e[%sm\e[0m ' "$escapes" "$escapes" # normal
      for style in 1 2 3 4 7 9; do  # bold, dim, italic, underline, reverse, strikethrough
        escapes="${intensity}${color};${style}"
        printf '\e[%sm\\e[%sm\e[0m ' "$escapes" "$style"
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
    # shellcheck disable=SC2012
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
  regex="($(IFS="|"; echo "${*//\//\\\/}"))"
  perl -pe "s/$regex/"$'\e\[7m$1\e\[27m/g'
}

# Make info pages act more like man pages
info() {
  command info --subnodes -o - "$@" | less
}

# Extract the corresponding lines
line() {
  sed -n "$(printf '%sp\n' "$@" | paste -sd';')"
}

# Display man pages with color
man() {
  GROFF_NO_SGR=1 \
    LESS_TERMCAP_md=$'\e[1;32m' \
    LESS_TERMCAP_me=$'\e[22;39m' \
    LESS_TERMCAP_so=$'\e[1;37;44m' \
    LESS_TERMCAP_se=$'\e[22;39;49m' \
    LESS_TERMCAP_us=$'\e[3;33m' \
    LESS_TERMCAP_ue=$'\e[23;39m' \
    command man "$@"
}

mkcd() {
  # shellcheck disable=SC2164
  mkdir -p "$1" && cd "$1"
}

open() {
  xdg-open "$1" &>/dev/null
}

# Open stdin for manual editing, then write it to stdout when saved
pedit() {
  local file
  file="$(mktemp -d)/pedit" || return
  nvim >/dev/tty - +"file $file" +"set noreadonly"
  [[ -f "$file" ]] && cat "$file" || return 1
}

# Return a string which, when evaluated by a shell, yields the original arguments
quote() {
  local quoted
  if (( $# )); then
    quoted=$(printf '%q ' "$@") && echo -n "${quoted% }"
  fi
}

rename-tmux-window() {
  [[ $TMUX ]] && tmux rename-window "$1"
}

repeat-prefix() {
  local matcher=${1:-'^[\w.-/]+'}
  local prefix new_prefix
  while IFS= read -r line; do
    if new_prefix=$(grep -Po "$matcher" <<<"$line"); then
      prefix=$new_prefix
    fi
    printf '%s\n' "$prefix${line:${#prefix}}"
  done
}

repeat-str() {
  local result=""
  local i
  for (( i=0; i<$2; i++ )); do
    result+=$1
  done
  echo "$result"
}

# Sort a file in-place (kinda)
sorti() {
  local file="$1"
  shift
  local tmp
  if tmp=$(mktemp); then
    sort "$@" -- "$file" >"$tmp" && mv -fT -- "$tmp" "$file"
  fi
}

stripcolors() {
  perl -pe 's/\e\[\d+(?>(;\d+)*)m//g'
}

# Replay the output of previous commands to stdout
that() {
  local arg=${1:--1}
  local start end
  if [[ $arg =~ ^-?[[:digit:]]+$ ]]; then
    start=$arg
    if (( start < 0 )); then
      (( start += _command_count ))
    fi
    end=$(( start + 1 ))
  elif [[ $arg =~ ^[[:digit:]]+-[[:digit:]]+$ ]]; then
    start=${arg/-*/}
    end=${arg/*-/}
  fi
  tmux capture-pane -eJp -S - -E - | perl -ne '
    if (/▶.*\['"$start"'\]/) {$p = 1}
    if (/([^▶]*)▶.*\['"$end"'\]/ && $p == 1) {print $1; exit}
    print if $p
  ' | sed '/▶.*\[/ s/\[[[:digit:]]\+\]//'
}

# Execute a command whenever a file is written
watchfile() {
  local git immediate
  declare -a args
  while (( $# > 0 )) && [[ $1 != -- ]]; do
    case "$1" in
      --git)
        git=yes
        ;;
      -i)
        immediate=yes
        ;;
      *)
        args+=("$1")
        ;;
    esac
    shift
  done
  shift
  if (( $# == 0 )); then
    echo >&2 "usage: watchfile [-i] FILE... -- CMD..."
    return 1
  fi
  if [[ $immediate ]]; then
    "$@"
  fi
  _wait() {
    if [[ $git ]]; then
      find . -mindepth 1 -name .git -prune -o -execdir git check-ignore -q {} \; -prune -o -print0 | xargs -x0 inotifywait -e modify -e attrib -e close_write -rq
    else
      inotifywait -e modify -e attrib -e close_write --exclude '\.git' -rq "${args[@]}"
    fi
  }
  while _wait "${args[@]}"; do
    printf >&2 "\e[1;33m>> Executing ${*@Q}\e[0m\n"
    "$@"
  done
}

_tmux-complete() {
  if (( COMP_KEY == 9 )); then
    # Invoked by Tab key; do nothing
    return
  fi
  local word_regex_escaped
  word_regex_escaped=$(sed 's/[.^$*+?()[{\|]/\\&/g' <<<"$2")
  local regex="\<${word_regex_escaped}[[:alnum:]_/.-]+\>"
  read -ra COMPREPLY < <(tmux capture-pane -Jp | sed '/^\s*$/d' | grep -Eo "$regex")
}
complete -o bashdefault -o default -D -F _tmux-complete

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

git_prompt_path=/usr/share/git/git-prompt.sh
if [[ $HOSTNAME == colinchan-fedora-* ]]; then
  git_prompt_path=/usr/share/git-core/contrib/completion/git-prompt.sh
fi
if [[ -e "$git_prompt_path" ]]; then
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWUPSTREAM=verbose
  source "$git_prompt_path"
  # shellcheck disable=SC2016
  gitstatus='$(__git_ps1 " (%s)")'
fi
unset git_prompt_path

_prompt_colors=(0 1 2 3 4 5 6)
_prompt_styles=(0 1 3 4)
_hashcolor() {
  local hash
  hash=$(echo -n "$1" | md5sum)
  local color_index=$(( 0x${hash:0:8} % ${#_prompt_colors[@]} ))
  local style_index=$(( 0x${hash:8:8} % ${#_prompt_styles[@]} ))
  local color=${_prompt_colors[color_index]}
  local style=${_prompt_styles[style_index]}
  if (( color == 0 && style == 0 )); then
    color=2
    style=4
  fi
  printf '\e[%s;3%sm' "$style" "$color"
}
# shellcheck disable=SC2016
color='\[$(_hashcolor "$USER@$HOSTNAME:$(pwd -P)")\]'
green='\[\e[32m\]'
black='\[\e[30m\]'
reset='\[\e[0m\]'
prefix=$(repeat-str '▶' "$SHLVL")
PS1=$reset$prefix' '$color'\u@\h:\W'$reset' '$black'[$((++_command_count))]'$reset'\n[\j]\$ '
SHORTPS1=$reset$green'[:\W]\$'$reset' '
: "${_command_count:=-1}"
