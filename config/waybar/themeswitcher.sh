#!/usr/bin/env bash
set -euo pipefail

themes_path="$HOME/.config/waybar/themes"

listThemes=()
listNames=""
listNames2=""

sleep 0.2 
options=$(find "$themes_path" -maxdepth 2 -type d)
for value in $options; do
    if [ "$value" != "$themes_path/assets" ] && [ "$value" != "$themes_path" ]; then
        if [ "$(find "$value" -maxdepth 1 -type d | wc -l)" = 1 ]; then
            result=$(echo "$value" | sed "s#$themes_path/##g")
            theme_folder=$(echo "$result" | cut -d'/' -f1)
            full_path="$result"
            listThemes+=("$theme_folder;/$result")
            if [ -f "$themes_path/$full_path/config.sh" ]; then
                source "$themes_path/$full_path/config.sh"
                listNames+="$theme_name"$'\n'
                listNames2+="$theme_name~"
            else
                listNames+="$theme_folder"$'\n'
                listNames2+="$theme_folder~"
            fi
        fi
    fi
done

listNames=${listNames::-2}
choice=$(echo -e "$listNames" | rofi -dmenu -replace -i -width 30 -p "Themes" -format i) || exit 0

input=$listNames2
IFS="~" read -ra array <<< "$input"

if [ "$choice" ]; then
    echo "Loading waybar theme..."
    echo "${listThemes[$choice]}" > ~/.cache/.themestyle.sh
    $HOME/.local/bin/waybar-launch
    notify-send "Waybar Theme changed" "to ${array[$choice]}" 2>/dev/null || true
fi
