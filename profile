export EDITOR=vim
export HISTCONTROL=ignoreboth
export HISTIGNORE="history:bg*:fg*:ls:ll:la:su"
export HISTSIZE=-1
export HISTFILESIZE=10000
export LESS='--chop-long-lines --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
export PAGER=less
export PATH=$PATH:$HOME/bin:$HOME/.gem/ruby/2.2.0/bin
export PYTHONSTARTUP=~/.pythonrc

if [[ $- == *i* ]]; then
    source ~/.bashrc
fi
