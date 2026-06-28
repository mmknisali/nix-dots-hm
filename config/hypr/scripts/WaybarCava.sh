#!/usr/bin/env bash
# Cava audio visualizer for waybar (requires cava installed)
if ! command -v cava >/dev/null 2>&1; then
  echo '[]'
  exit 0
fi
# Simplified cava output
cava -p /dev/stdin <<'EOF' 2>/dev/null | head -1 || echo "[]"
[general]
bars = 8
framerate = 5
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 8
bar_delimiter = 32
EOF
