export EDITOR=nvim
export FREETYPE_PROPERTIES='truetype:interpreter-version=40'
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export LESS='--chop-long-lines --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
export PAGER=less
export PATH=$PATH:$HOME/bin:$HOME/.gem/ruby/2.2.0/bin
export PYTHONDONTWRITEBYTECODE=yes
export PYTHONSTARTUP=~/.pythonrc
export RSYNC_PROTECT_ARGS=1
export TERMINAL=gnome-terminal
export WINEDLLOVERRIDES='winemenubuilder.exe=d'

if [ -z "$SSH_AUTH_SOCK" ] && pgrep -f gnome-keyring-daemon ; then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi
