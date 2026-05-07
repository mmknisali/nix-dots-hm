#!/usr/bin/env bash
# Toggle blur effect in Hyprland

current_blur=$(hyprctl getoption decoration:blur:enabled -j 2>/dev/null | jq -r '.int')

if [ "$current_blur" = "1" ]; then
    hyprctl keyword decoration:blur:enabled false
    notify-send "Blur" "Blur disabled"
else
    hyprctl keyword decoration:blur:enabled true
    notify-send "Blur" "Blur enabled"
fi
