#!/usr/bin/env bash
# NixOS system update
#
# DOTS_DIR points at this dotfiles repository. It defaults to ~/.dotfiles and
# can be overridden with the DOTS_DIR environment variable.
DOTS_DIR="${DOTS_DIR:-$HOME/.dotfiles}"

if [ ! -d "$DOTS_DIR" ]; then
	notify-send "System Update" "Dotfiles not found at $DOTS_DIR (set DOTS_DIR)"
	exit 1
fi

notify-send "System Update" "Building NixOS configuration..."
kitty --hold sh -c "sudo nixos-rebuild switch --flake path:$DOTS_DIR#clara 2>&1; echo; echo 'Done. Press any key to exit.'; read -n1"
