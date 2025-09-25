#!/bin/bash

# Interactive theme menu using tofi itself
THEME_SWITCHER="/home/jeremy/.config/tofi/scripts/theme-switcher.sh"

SELECTED=$(echo -e "fullscreen\nsoy-milk" | tofi --prompt-text "Select theme: ")

if [ -n "$SELECTED" ]; then
    "$THEME_SWITCHER" "$SELECTED"
fi