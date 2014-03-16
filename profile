export EDITOR=vim
export HISTCONTROL=ignoreboth
export HISTIGNORE="history:bg*:fg*:ls:ll:la:su"
export HISTSIZE=5000
export LESS='--chop-long-lines --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
export PATH=$PATH:$HOME/dotfiles:$HOME/bin:$HOME/.gem/ruby/2.0.0/bin
export PYTHONSTARTUP=~/.pythonrc

# Set up gnome-keyring-daemon (for ssh agent functionality)
#eval $(gnome-keyring-daemon --start)
#export GNOME_KEYRING_CONTROL GPG_AGENT_INFO SSH_AUTH_SOCK

# Source bashrc for aliases and functions
source ~/.bashrc
