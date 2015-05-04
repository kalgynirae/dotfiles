#!/bin/bash

THRESHOLD=10

while sleep 1m; do
    previous_capacity=${capacity:-100}
    capacity=$(</sys/class/power_supply/BAT1/capacity)
    if (( $capacity < $THRESHOLD )); then
        if (( $capacity < $previous_capacity )); then
            notify-send --icon=battery --hint=int:value:$capacity \
                "Battery getting low: $capacity%"
        fi
    fi
done
