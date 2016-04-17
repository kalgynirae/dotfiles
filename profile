export EDITOR=vim
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export LESS='--chop-long-lines --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
export PAGER=less
export PATH=$PATH:$HOME/bin:$HOME/.gem/ruby/2.2.0/bin
export PYTHONSTARTUP=~/.pythonrc

eval $(ssh-agent)

if [[ $- == *i* ]]; then
    source ~/.bashrc
fi
