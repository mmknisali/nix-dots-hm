#!/usr/bin/env bash
# Check for flake updates
notify-send "Checking for updates..." "Running nix flake update..."
(cd ~/.dotfiles && nix flake update && notify-send "Updates applied" "Rebuild with: sudo nixos-rebuild switch --flake .#clara") &
