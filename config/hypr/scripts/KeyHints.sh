#!/usr/bin/env bash
# Show keybinding hints
cat <<'EOF' | rofi -dmenu -p "Keybinds" -markup -theme-str 'listview {lines: 20;}'
Super+Q: Close window
Super+W: Toggle float
Super+T: Terminal
Super+B: Browser
Super+A: Rofi launcher
Super+L: Lock screen
Super+R: Run
Super+F: Fullscreen
Super+E: File manager
Super+V: Clipboard (cliphist)
Super+P: Screenshot region
Super+Shift+P: Color picker
Super+S: Toggle special workspace
Super+1-9: Switch workspace
Super+Shift+1-9: Move window to workspace
Alt+F4: Close window
Print: Screenshot output
F10: Toggle mute
F11/F12: Volume down/up
EOF
