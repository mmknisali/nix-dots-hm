#!/usr/bin/env bash
# Volume control script for waybar

increment="5%"

case "${1:-}" in
    --inc)
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ "$increment+"
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
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ "$increment+"
        ;;
    --mic-dec)
        wpctl set-volume @DEFAULT_AUDIO_SOURCE@ "$increment-"
        ;;
    *)
        echo "Usage: $0 {--inc|--dec|--toggle|--toggle-mic|--mic-inc|--mic-dec}"
        exit 1
        ;;
esac
