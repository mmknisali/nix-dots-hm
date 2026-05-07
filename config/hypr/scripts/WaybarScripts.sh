#!/usr/bin/env bash
# Launch system monitors

case "$1" in
    --nvtop)
        kitty --class nvtop -e nvtop
        ;;
    --btop)
        kitty --class btop -e btop
        ;;
    *)
        echo "Usage: $0 {--nvtop|--btop}"
        exit 1
        ;;
esac
