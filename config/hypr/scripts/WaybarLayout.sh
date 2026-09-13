#!/usr/bin/env bash
# Switch waybar layout via rofi (lists configs in ~/.config/waybar/configs/)
config_dir=~/.config/waybar/configs
if [ ! -d "$config_dir" ]; then
  notify-send "Waybar" "No layout configs found"
  exit 1
fi
layout=$(find "$config_dir" -maxdepth 1 -type f -printf '%f\n' | sort | rofi -dmenu -p "Waybar Layout" -theme-str 'listview {lines: 10;}')
[ -n "$layout" ] && cp --remove-destination "$config_dir/$layout" ~/.config/waybar/config && systemctl --user restart waybar.service
