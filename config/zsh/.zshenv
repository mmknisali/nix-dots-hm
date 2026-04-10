#!/usr/bin/env zsh

#! ██████╗░░█████╗░  ███╗░░██╗░█████╗░████████╗  ███████╗██████╗░██╗████████╗
#! ██╔══██╗██╔══██╗  ████╗░██║██╔══██╗╚══██╔══╝  ██╔════╝██╔══██╗██║╚══██╔══╝
#! ██║░░██║██║░░██║  ██╔██╗██║██║░░██║░░░██║░░░  █████╗░░██║░░██║██║░░░██║░░░
#! ██║░░██║██║░░██║  ██║╚████║██║░░██║░░░██║░░░  ██╔══╝░░██║░░██║██║░░░██║░░░
#! ██████╔╝╚█████╔╝  ██║░╚███║╚█████╔╝░░░██║░░░  ███████╗██████╔╝██║░░░██║░░░
#! ╚═════╝░░╚════╝░  ╚═╝░░╚══╝░╚════╝░░░░╚═╝░░░  ╚══════╝╚═════╝░╚═╝░░░╚═╝░░░

# Load all custom module files // Directories are ignored
# As Directories are ignored, we can store a bunch of boilerplate script in a ``./conf.d/custom-directory``
# then we can make an entry point script: `./conf.d/custom-directory.zsh`managing all the files in that directory

conf_dir="${ZDOTDIR:-$HOME/.config/zsh}/conf.d"
if [ -d "$conf_dir" ]; then
  for file in "$conf_dir"/*.zsh; do
    [ -f "$file" ] && [ -r "$file" ] && source "$file"
  done
fi

# Start Hyprland if not already running (for autologin)
if [ -z "$HYPRLAND_INSTANCE_SIGNAL" ]; then
    exec Hyprland
fi
