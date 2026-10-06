#!/usr/bin/env bash
set -euo pipefail

# Select wallpaper via rofi
wall_dir=~/Pictures/wallpapers
if [ ! -d "$wall_dir" ]; then
  notify-send "Wallpaper" "No wallpaper directory at $wall_dir"
  exit 1
fi
wall=$(find "$wall_dir" -maxdepth 1 -type f -printf '%f\n' | sort | rofi -dmenu -p "Wallpaper" -theme-str 'listview {lines: 10;}')
[ -n "$wall" ] && hyprctl hyprpaper reload ",$wall_dir/$wall"
