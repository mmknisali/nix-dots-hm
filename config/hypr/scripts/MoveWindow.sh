#!/usr/bin/env bash
set -euo pipefail

if [ "$(hyprctl activewindow -j | jq -r '.floating // false')" = "true" ]; then
  hyprctl dispatch moveactive "$1" "$2"
else
  hyprctl dispatch movewindow "$3"
fi
