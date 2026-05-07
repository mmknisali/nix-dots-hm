#!/usr/bin/env bash
# Volume control script for waybar

increment="5%"

# Get the default sink
get_default_sink() {
    wpctl inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | head -1 | cut -d' ' -f3
}

# Get volume level
get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print int($2 * 100)}'
}

# Check if muted
is_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -q "MUTED"
}

case "$1" in
    --inc)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "$increment+"
        ;;
    --dec)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "$increment-"
        ;;
    --toggle)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    --toggle-mic)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        ;;
    --mic-inc)
        wpctl set-volume @DEFAULT_AUDIO_SOURCE@ "$increment+"
        ;;
    --mic-dec)
        wpctl set-volume @DEFAULT_AUDIO_SOURCE@ "$increment-"
        ;;
    *)
        echo "Usage: $0 {--inc|--dec|--toggle|--toggle-mic|--mic-inc|--mic-dec}"
        exit 1
        ;;
esac
