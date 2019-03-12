#!/bin/bash
# based on transfer-sleep-lock-i3lock.sh from xss-lock

i3lock_options=(--image ~/.cache/wallpaper-lock.png --tiling --show-failed-attempts)

kill_and_unpause_notifications() {
  pkill -xu $EUID i3lock
  pkill -xu $EUID -USR2 dunst
}

if [[ -e /dev/fd/${XSS_SLEEP_LOCK_FD:--1} ]]; then
  trap kill_and_unpause_notifications TERM INT

  # Pause notifications
  pkill -xu $EUID -USR1 dunst

  # Prevent i3lock from inheriting a copy of the lock fd
  i3lock "${i3lock_options[@]}" {XSS_SLEEP_LOCK_FD}<&-

  # Close the fd to indicate we're ready to sleep
  exec {XSS_SLEEP_LOCK_FD}<&-

  while pkill -xu $EUID -0 i3lock; do
    sleep 0.5
  done

  # Unpause notifications
  pkill -xu $EUID -USR2 dunst
else
  trap kill_and_unpause_notifications TERM INT
  pkill -xu $EUID -USR1 dunst
  i3lock -n "${i3lock_options[@]}" &
  wait
  pkill -xu $EUID -USR2 dunst
fi
