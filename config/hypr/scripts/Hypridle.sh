#!/usr/bin/env bash
# Toggle hypridle
if pgrep -x hypridle >/dev/null 2>&1; then
  pkill hypridle
  notify-send "Hypridle" "Disabled"
  echo '{"text": "󰅶 ", "tooltip": "Idle: disabled", "class": "notactive"}'
else
  hypridle &
  notify-send "Hypridle" "Enabled"
  echo '{"text": "󰾪 ", "tooltip": "Idle: enabled", "class": "active"}'
fi
