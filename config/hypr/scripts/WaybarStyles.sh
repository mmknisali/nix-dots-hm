#!/usr/bin/env bash
# Restart Waybar to reload the declaratively selected layout and style.
set -euo pipefail

systemctl --user restart waybar.service
notify-send "Waybar" "Restarted Waybar to reload its configured layout and style. Select them with dotfiles.waybar.layout and dotfiles.waybar.style, then rebuild your configuration."
