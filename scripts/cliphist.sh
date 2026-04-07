#!/usr/bin/env zsh
set -euo pipefail

case "${1:-}" in
  d)
    cliphist list | rofi -dmenu | cliphist delete
    ;;
  w)
    cliphist list | cliphist decode | wl-copy
    ;;
  *)
    cliphist list | rofi -dmenu | cliphist decode | wl-copy
    ;;
esac
