#!/bin/sh
export PATH=$PATH:$HOME/bin:$HOME/.gem/bin:$HOME/.local/bin

if command -v nvim >/dev/null; then
  EDITOR=nvim
  export MANPAGER='nvim +Man!'
else
  EDITOR=vim
fi

export COLORTERM=truecolor
export DIFFPROG="$EDITOR -d"
export EDITOR
export FREETYPE_PROPERTIES=truetype:interpreter-version=40
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export LESS='--chop-long-lines --ignore-case --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
export MOZ_ENABLE_WAYLAND=1
export MOZ_USE_XINPUT2=1  # Smooth touchpad scrolling in Firefox
export PAGER=less
export PYTHONDONTWRITEBYTECODE=yes
export PYTHONSTARTUP=~/.pythonrc
export RSYNC_PROTECT_ARGS=1
export TERMINAL=alacritty
export WINEDLLOVERRIDES=winemenubuilder.exe=d

#export CLUTTER_BACKEND=wayland
#export GDK_BACKEND=wayland
#export QT_QPA_PLATFORM=wayland
#export SDL_VIDEODRIVER=wayland

if [ "$(tty)" = /dev/tty1 ]; then
  systemctl --user import-environment
  sway
fi
