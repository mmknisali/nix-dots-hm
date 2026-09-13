#!/usr/bin/env bash
set -euo pipefail

status() {
  if systemctl --user is-active --quiet hypridle.service; then
    echo '{"text": "󰾪 ", "tooltip": "Idle: enabled", "class": "active"}'
  else
    echo '{"text": "󰅶 ", "tooltip": "Idle: disabled", "class": "notactive"}'
  fi
}

case "${1:-status}" in
  status)
    status
    ;;
  toggle)
    if systemctl --user is-active --quiet hypridle.service; then
      systemctl --user stop hypridle.service
      notify-send "Hypridle" "Disabled"
    else
      systemctl --user start hypridle.service
      notify-send "Hypridle" "Enabled"
    fi
    status
    ;;
  *)
    echo "Usage: $0 [status|toggle]" >&2
    exit 2
    ;;
esac
