#!/bin/sh
export EDITOR=nvim
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export LESS='--chop-long-lines --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
export PAGER=less
export PATH=$PATH:$HOME/bin:$HOME/.gem/ruby/2.2.0/bin
export PYTHONDONTWRITEBYTECODE=yes
export PYTHONSTARTUP=~/.pythonrc
export TERMINAL=gnome-terminal
export WINEDLLOVERRIDES='winemenubuilder.exe=d'

eval $(ssh-agent)

if [ -n "$BASH_VERSION" ]; then
    . ~/.bashrc  # This returns immediately if the shell is not interactive
fi
