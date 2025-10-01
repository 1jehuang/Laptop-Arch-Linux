#!/bin/bash

# Check if focused window is Alacritty
focused_app=$(niri msg -j windows | jq -r '.[] | select(.is_focused == true) | .app_id')

if [ "$focused_app" != "Alacritty" ]; then
    notify-send "Not Alacritty" "Focus an Alacritty window first"
    exit 1
fi

# Enter Vi mode
wtype -M ctrl -M shift -k space -m shift -m ctrl
sleep 0.1

# Type ggVGy (go to top, visual line mode to bottom, yank)
wtype -k g -k g
sleep 0.05
wtype -M shift -k v -m shift
sleep 0.05
wtype -M shift -k g -m shift
sleep 0.05
wtype -k y

# Exit Vi mode with Ctrl+Shift+Space
sleep 0.05
wtype -M ctrl -M shift -k space -m shift -m ctrl

notify-send "Copied" "Alacritty buffer copied to clipboard"
