#!/usr/bin/env bash
# Set a random wallpaper
wall_dir=~/Pictures/wallpapers
[ -d "$wall_dir" ] || exit 1
wall=$(find "$wall_dir" -maxdepth 1 -type f -print0 | shuf -z -n1 | tr '\0' '\n')
[ -n "$wall" ] && hyprctl hyprpaper wallpaper ",$wall"
