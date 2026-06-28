#!/usr/bin/env bash
# Set a random wallpaper
wall_dir=~/Pictures/wallpapers
if [ ! -d "$wall_dir" ]; then
  exit 1
fi
wall=$(ls "$wall_dir" 2>/dev/null | shuf -n 1)
[ -n "$wall" ] && hyprctl hyprpaper wallpaper ",$wall_dir/$wall"
