#!/usr/bin/env bash
# Check for flake updates
#
# DOTS_DIR points at this dotfiles repository. It defaults to ~/.dotfiles and
# can be overridden with the DOTS_DIR environment variable.
DOTS_DIR="${DOTS_DIR:-$HOME/.dotfiles}"

if [ ! -d "$DOTS_DIR" ]; then
	notify-send "Flake Update" "Dotfiles not found at $DOTS_DIR (set DOTS_DIR)"
	exit 1
fi

notify-send "Checking for updates..." "Running nix flake update..."
(cd "$DOTS_DIR" && nix flake update && notify-send "Updates applied" "Rebuild with: sudo nixos-rebuild switch --flake path:.#clara") &
