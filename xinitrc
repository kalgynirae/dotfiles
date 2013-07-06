#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Attempt to set up the displays properly
xrandr --output HDMI1 --auto --pos 0x0 \
       --output LVDS1 --auto --pos 1920x312
#xset dpms 0 0 300

## Keyboard settings
xset r rate 200 35
numlockx

# Applets and such
nm-applet &

# Compositor and window manager
compton -c -r 10 -t -13 -l -13 -o 0.5 &
sh /home/lumpy/.graphicalrc
exec awesome
