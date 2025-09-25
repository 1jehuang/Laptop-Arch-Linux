#!/bin/bash

# Tofi Theme Switcher
THEME_DIR="/home/jeremy/.config/tofi/themes"
CONFIG_FILE="/home/jeremy/.config/tofi/config"

case "$1" in
    "fullscreen")
        cp "$THEME_DIR/fullscreen.conf" "$CONFIG_FILE"
        notify-send "Tofi Theme" "Switched to Fullscreen theme" -t 2000
        ;;
    "soy-milk")
        cp "$THEME_DIR/soy-milk.conf" "$CONFIG_FILE"
        notify-send "Tofi Theme" "Switched to Soy-Milk theme" -t 2000
        ;;
    "list")
        echo "Available themes:"
        echo "  fullscreen"
        echo "  soy-milk"
        ;;
    *)
        echo "Usage: $0 {fullscreen|soy-milk|list}"
        echo "Current theme:"
        if grep -q "horizontal = true" "$CONFIG_FILE"; then
            echo "  soy-milk"
        else
            echo "  fullscreen"
        fi
        ;;
esac