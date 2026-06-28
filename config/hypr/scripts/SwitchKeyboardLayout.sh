#!/usr/bin/env bash
# Switch keyboard layout via rofi
layout=$(printf "us\ntr" | rofi -dmenu -p "Keyboard Layout")
[ -n "$layout" ] && hyprctl switchxkblayout "at-translated-set-2-keyboard" next
