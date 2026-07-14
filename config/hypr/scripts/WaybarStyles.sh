#!/usr/bin/env bash
# Restart waybar (styles are reloaded from files)
pkill -x waybar
sleep 0.2
waybar >/dev/null 2>&1 &
