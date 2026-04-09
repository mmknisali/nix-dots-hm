#!/usr/bin/env bash
#  _____ _                                       _ _       _                
# |_   _| |__   ___ _ __ ___   ___  _____      _(_) |_ ___| |__   ___ _ __  
#   | | | '_ \ / _ \ '_ ` _ \ / _ \/ __\ \ /\ / / | __/ __| '_ \ / _ \ '__| 
#   | | | | | |  __/ | | | | |  __/\__ \\ V  V /| | || (__| | | |  __/ |    
#   |_| |_| |_|\___|_| |_| |_|\___||___/ \_/\_/ |_|\__\___|_| |_|\___|_|    
#                                                                           
# by Stephan Raabe (2024) 
# ----------------------------------------------------- 

# ----------------------------------------------------- 
# Default theme folder
# ----------------------------------------------------- 
themes_path="$HOME/.config/waybar/themes"

# ----------------------------------------------------- 
# Initialize arrays
# ----------------------------------------------------- 
listThemes=""
listNames=""
listNames2=""

# ----------------------------------------------------- 
# Read theme folder
# -----------------------------------------------------
sleep 0.2 
options=$(find $themes_path -maxdepth 2 -type d)
for value in $options
do
    if [ ! $value == "$themes_path/assets" ]; then
        if [ ! $value == "$themes_path" ]; then
            if [ $(find $value -maxdepth 1 -type d | wc -l) = 1 ]; then
                result=$(echo $value | sed "s#$themes_path/##g")
                theme_folder=$(echo $result | cut -d'/' -f1)
                full_path="/$result"
                listThemes[${#listThemes[@]}]="$theme_folder;$full_path"
                if [ -f $themes_path/$full_path/config.sh ]; then
                    source $themes_path/$full_path/config.sh
                    listNames+="$theme_name\n"
                    listNames2+="$theme_name~"
                else
                    listNames+="$theme_folder\n"
                    listNames2+="$theme_folder~"
                fi
            fi
        fi
    fi
done

# ----------------------------------------------------- 
# Show rofi dialog
# ----------------------------------------------------- 
listNames=${listNames::-2}
choice=$(echo -e "$listNames" | rofi -dmenu -replace -i -width 30 -p "Themes" -format i)
IFS="~"
input=$listNames2
read -ra array <<< "$input"

# ----------------------------------------------------- 
# Set new theme by writing the theme information to ~/.cache/.themestyle.sh
# ----------------------------------------------------- 
if [ "$choice" ]; then
    echo "Loading waybar theme..."
    echo "${listThemes[$choice+1]}" > ~/.cache/.themestyle.sh
    $HOME/.local/bin/waybar-launch
    notify-send "Waybar Theme changed" "to ${array[$choice]}"
fi
