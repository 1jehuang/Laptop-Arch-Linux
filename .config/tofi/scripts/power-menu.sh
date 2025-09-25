#!/bin/bash

# Power menu options with icons (using Nerd Font icons)
declare -A options=(
    ["  Lock Screen"]="swaylock"
    ["  Logout"]="loginctl terminate-session"
    ["  Suspend"]="systemctl suspend"
    ["  Hibernate"]="systemctl hibernate"
    ["  Reboot"]="systemctl reboot"
    ["  Shutdown"]="systemctl poweroff"
    ["  Cancel"]="exit 0"
)

# Create menu string
menu=""
for option in "  Lock Screen" "  Logout" "  Suspend" "  Hibernate" "  Reboot" "  Shutdown" "  Cancel"; do
    menu+="$option\n"
done

# Show menu with custom config
selected=$(echo -e "$menu" | tofi --config ~/.config/tofi/power-menu.conf)

# Execute selected command
if [[ -n "$selected" ]] && [[ -n "${options[$selected]}" ]]; then
    # For dangerous operations, add confirmation
    case "$selected" in
        *"Shutdown"*|*"Reboot"*|*"Logout"*)
            confirm=$(echo -e "Yes\nNo" | tofi --prompt-text "Confirm $selected? ")
            [[ "$confirm" == "Yes" ]] && eval "${options[$selected]}"
            ;;
        *)
            eval "${options[$selected]}"
            ;;
    esac
fi