#!/usr/bin/env bash
# Switch waybar layout via rofi (lists configs in ~/.config/waybar/configs/)
config_dir=~/.config/waybar/configs
if [ ! -d "$config_dir" ]; then
  notify-send "Waybar" "No layout configs found"
  exit 1
fi
layout=$(ls "$config_dir" | rofi -dmenu -p "Waybar Layout" -theme-str 'listview {lines: 10;}')
[ -n "$layout" ] && cp "$config_dir/$layout" ~/.config/waybar/config && pkill waybar && sleep 0.2 && waybar
