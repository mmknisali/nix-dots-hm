#!/usr/bin/env bash
# Select wallpaper via rofi
wall_dir=~/Pictures/wallpapers
if [ ! -d "$wall_dir" ]; then
  notify-send "Wallpaper" "No wallpaper directory at $wall_dir"
  exit 1
fi
wall=$(ls "$wall_dir" | rofi -dmenu -p "Wallpaper" -theme-str 'listview {lines: 10;}')
[ -n "$wall" ] && hyprctl hyprpaper wallpaper ",$wall_dir/$wall"
