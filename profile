#!/bin/sh
export PATH=$PATH:$HOME/bin:$HOME/.gem/ruby/2.6.0/bin

if command -v nvim >/dev/null; then
  EDITOR=nvim
else
  EDITOR=vim
fi

export COLORTERM=truecolor
export DIFFPROG="$EDITOR -d"
export EDITOR
export FREETYPE_PROPERTIES='truetype:interpreter-version=40'
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export LESS='--chop-long-lines --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
export MOZ_USE_XINPUT2=1  # Smooth touchpad scrolling in Firefox
export PAGER=less
export PYTHONDONTWRITEBYTECODE=yes
export PYTHONSTARTUP=~/.pythonrc
export RSYNC_PROTECT_ARGS=1
export TERMINAL=alacritty
export WINEDLLOVERRIDES='winemenubuilder.exe=d'

if [ -z "$SSH_AUTH_SOCK" ] && pgrep -f gnome-keyring-daemon ; then
  eval "$(gnome-keyring-daemon --start)"
  export SSH_AUTH_SOCK
fi
