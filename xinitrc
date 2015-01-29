#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xkbcomp -I$HOME/dotfiles/xkb $HOME/dotfiles/keymap.xkb $DISPLAY
exec i3
