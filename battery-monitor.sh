#!/bin/sh

THRESHOLD=5

previous_capacity=$(cat /sys/class/power_supply/BAT1/capacity)
while sleep 1m; do
    capacity=$(cat /sys/class/power_supply/BAT1/capacity)
    if [[ $capacity -lt $THRESHOLD && $previous_capacity -ge $THRESHOLD ]]; then
        systemctl suspend
    fi

    if [ $capacity -ne $previous_capacity ]; then
        #if [ $capacity -lt $previous_capacity ]; then
        #    notify-send --icon=battery --hint=int:value:$capacity \
        #        "Battery discharging: $capacity%"
        #fi
        previous_capacity=$capacity
    fi
done
