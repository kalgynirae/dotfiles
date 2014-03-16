#!/bin/sh

op=${1:-lolnope}
if [ $op == "up" ]; then
    change=10%+
elif [ $op == "down" ]; then
    change=10%-
elif [ $op == "mute" ]; then
    change=toggle
elif [ $op == "set" ]; then
    change=$2
else
    echo "Usage: $(basename $0) [up|down|mute|set <value>]" 1>&2
    exit 1
fi

amixer -D pulse set Master "$change"

current=$(amixer -D pulse get Master | \
          grep -om 1 '[[:digit:]]\{1,3\}%' | \
          sed 's/%$//')

if [ $current -le 33 ]; then
    icon=audio-volume-low
elif [ $current -le 67 ]; then
    icon=audio-volume-medium
elif [ $current -gt 67 ]; then
    icon=audio-volume-high
else
    icon=audio-volume-off
fi

if amixer -D pulse get Master | grep -q 'off'; then
    icon=audio-volume-muted
    current=0
fi

# Notify-send way. Disabled because there's no way to replace a previous
# notification, so they stack up annoyingly.
#notify-send -i $icon -h int:value:$current "Volume: $current%"

# Dbus-send way. Doesn't work because dbus-send doesn't support passing an
# array of variants.
#dbus-send \
#    --print-reply --dest=org.freedesktop.Notifications \
#    /org/freedesktop/Notifications org.freedesktop.Notifications.Notify \
#    string:"Volume" uint32:1 string:"$icon" \
#    string:"" string:"Volume: $current%" \
#    array:string:'' dict:string:string:'','' int32:2
