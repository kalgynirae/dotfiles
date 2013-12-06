#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Attempt to set up the displays properly
/home/lumpy/dotfiles/refresh-monitors

# Compositor and window manager
compton -c -r 10 -t -13 -l -13 -o 0.5 &
exec i3
