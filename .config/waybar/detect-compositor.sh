#!/bin/bash

# Detect which compositor is running and launch waybar with appropriate config

if pgrep -x "niri" > /dev/null; then
    exec waybar -c ~/.config/waybar/config-niri
elif pgrep -x "Hyprland" > /dev/null; then
    exec waybar -c ~/.config/waybar/config-hyprland
else
    # Fallback to default config
    exec waybar
fi