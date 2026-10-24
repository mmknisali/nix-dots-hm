#!/usr/bin/env bash
# Show the keybind cheat sheet.
#
# The list is generated from the binds that Hyprland currently has loaded, so
# it always matches the running configuration.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

"${SCRIPT_DIR}/KeyHints.py" | rofi -dmenu -i -p "Keybinds" -lines 20 -theme-str 'window {width: 62%;}'
