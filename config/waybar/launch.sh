#!/usr/bin/env bash
#  ____  _             _    __        __          _                 
# / ___|| |_ __ _ _ __| |_  \ \      / /_ _ _   _| |__   __ _ _ __  
# \___ \| __/ _` | '__| __|  \ \ /\ / / _` | | | | '_ \ / _` | '__| 
#  ___) | || (_| | |  | |_    \ V  V / (_| | |_| | |_) | (_| | |    
# |____/ \__\__,_|_|   \__|    \_/\_/ \__,_|\__, |_.__/ \__,_|_|    
#                                           |___/                   
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# Check if waybar-disabled file exists
if [ -f $HOME/.cache/waybar-disabled ] ;then 
    killall waybar
    pkill waybar
    exit 1 
fi

# ----------------------------------------------------- 
# Quit all running waybar instances
# ----------------------------------------------------- 
pkill waybar 2>/dev/null
sleep 0.2

# ----------------------------------------------------- 
# Default theme: /THEMEFOLDER;/VARIATION
# ----------------------------------------------------- 
themestyle="/ml4w-blur-bottom;/ml4w-blur-bottom/dark"

# ----------------------------------------------------- 
# Get current theme information from .cache/.themestyle.sh
# ----------------------------------------------------- 
if [ -f ~/.cache/.themestyle.sh ]; then
    themestyle=$(cat ~/.cache/.themestyle.sh)
else
    touch ~/.cache/.themestyle.sh
    echo "$themestyle" > ~/.cache/.themestyle.sh
fi

IFS=';' read -ra arrThemes <<< "$themestyle"
echo ":: Theme: ${arrThemes[0]} - ${arrThemes[1]}"

theme_config="$HOME/.config/waybar/themes/${arrThemes[0]}/config"
theme_style="$HOME/.config/waybar/themes/${arrThemes[1]}/style.css"

if [ ! -f "$theme_style" ]; then
    themestyle="/ml4w-blur-bottom;/ml4w-blur-bottom/dark"
    IFS=';' read -ra arrThemes <<< "$themestyle"
    theme_config="$HOME/.config/waybar/themes/${arrThemes[0]}/config"
    theme_style="$HOME/.config/waybar/themes/${arrThemes[1]}/style.css"
fi

if [ ! -f "$theme_config" ]; then
    theme_config="$HOME/.config/waybar/themes/${arrThemes[0]}/config-custom"
fi

if [ -f "$HOME/.config/waybar/themes/${arrThemes[1]}/style-custom.css" ]; then
    theme_style="$HOME/.config/waybar/themes/${arrThemes[1]}/style-custom.css"
fi

waybar -c "$theme_config" -s "$theme_style" &
