#!/usr/bin/env bash
# NixOS system update
notify-send "System Update" "Building NixOS configuration..."
kitty --hold sh -c "sudo nixos-rebuild switch --flake path:$HOME/.dotfiles#clara 2>&1; echo; echo 'Done. Press any key to exit.'; read -n1"
