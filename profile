export EDITOR=vim
export HISTCONTROL=ignoreboth
export HISTIGNORE="history:bg*:fg*:ls:ll:la:su"
export HISTSIZE=5000
export LESS='--chop-long-lines --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
export PAGER=less
export PATH=$PATH:$HOME/dotfiles/lumeh-scripts:$HOME/bin:$HOME/.gem/ruby/2.2.0/bin
export PYTHONSTARTUP=~/.pythonrc

if [[ -n $DISPLAY ]]; then
    export $(gnome-keyring-daemon --start)
fi

if [[ $- == *i* && -r ~/.bashrc ]]; then
    source ~/.bashrc
fi
