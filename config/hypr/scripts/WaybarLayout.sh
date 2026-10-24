#!/usr/bin/env bash
# Layout and style are selected declaratively, not copied over managed files.
exec notify-send "Waybar Configuration" 'Set these Home Manager options:
dotfiles.waybar.layout: filename from config/waybar/configs/
dotfiles.waybar.style: filename from config/waybar/style/
Then rebuild your configuration. This shortcut does not change managed files.'
