#!/bin/sh

# systemd env -> this shell
eval "$(systemctl --user show-environment | sed 's/^/export /')"
unset SYSTEMD_EXEC_PID

# Start gnome-keyring-daemon
if [ -z "$SSH_AUTH_SOCK" ] && pgrep -f gnome-keyring-daemon; then
  eval "$(gnome-keyring-daemon --start)"
  export SSH_AUTH_SOCK
fi

# login session env -> systemd
vars_to_import="
  SSH_AUTH_SOCK
  XDG_SEAT
  XDG_SESSION_CLASS
  XDG_SESSION_ID
  XDG_VTNR
"
# shellcheck disable=SC2086
systemctl --user import-environment $vars_to_import
