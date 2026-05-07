#!/usr/bin/env bash
# Brightness control script for waybar

increment="5%"

case "$1" in
    --inc)
        brightnessctl set "$increment+"
        ;;
    --dec)
        brightnessctl set "$increment-"
        ;;
    *)
        echo "Usage: $0 {--inc|--dec}"
        exit 1
        ;;
esac
