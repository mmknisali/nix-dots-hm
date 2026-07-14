#!/usr/bin/env bash
# Launch system monitors / helpers from Waybar custom modules

case "$1" in
    --nvtop)
        kitty --class nvtop -e nvtop
        ;;
    --btop)
        kitty --class btop -e btop
        ;;
    --files)
        dolphin
        ;;
    --term)
        kitty
        ;;
    *)
        echo "Usage: $0 {--nvtop|--btop|--files|--term}"
        exit 1
        ;;
esac
