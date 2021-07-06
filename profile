#!/bin/sh

eval "$(systemctl --user show-environment | sed 's/^/export /')"
unset SYSTEMD_EXEC_PID

if [ -z "$SSH_AUTH_SOCK" ] && pgrep -f gnome-keyring-daemon; then
  eval "$(gnome-keyring-daemon --start)"
  export SSH_AUTH_SOCK
fi

vars_to_import="
  SSH_AUTH_SOCK
  XDG_SEAT
  XDG_SESSION_CLASS
  XDG_SESSION_ID
  XDG_VTNR
"

if [ "$(tty)" = /dev/tty1 ]; then
  # shellcheck disable=SC2086
  systemctl --user import-environment $vars_to_import
  systemctl --user start --wait sway.service
fi
