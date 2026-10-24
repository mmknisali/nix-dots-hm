#!/usr/bin/env bash
# Toggle blur effect in Hyprland
set -euo pipefail

result=$(hyprctl eval 'hl.config({ decoration = { blur = { enabled = not hl.get_config("decoration.blur.enabled") } } })')

# Some IPC errors (such as using the legacy config parser) still exit zero.
if [[ "$result" != "ok" ]]; then
    printf 'Failed to toggle blur: %s\n' "$result" >&2
    exit 1
fi

notify-send "Blur" "Blur toggled"
