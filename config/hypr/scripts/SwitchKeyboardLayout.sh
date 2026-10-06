#!/usr/bin/env bash
set -euo pipefail

# Switch keyboard layout via rofi
layout=$(printf "us\ntr" | rofi -dmenu -p "Keyboard Layout")
case "$layout" in
  us) hyprctl switchxkblayout all 0 ;;
  tr) hyprctl switchxkblayout all 1 ;;
esac
