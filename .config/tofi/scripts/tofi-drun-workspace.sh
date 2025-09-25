#!/bin/bash

# Get current workspace before launching tofi
CURRENT_WORKSPACE=$(niri msg workspaces | grep "focused: true" | grep -o '"name": "[^"]*"' | cut -d'"' -f4)
if [ -z "$CURRENT_WORKSPACE" ]; then
    # Fallback to workspace index if name is not available
    CURRENT_WORKSPACE=$(niri msg workspaces | grep "focused: true" | grep -o '"idx": [0-9]*' | cut -d':' -f2 | tr -d ' ')
fi

# Launch tofi-drun and capture the selection
SELECTION=$(tofi-drun)

# If something was selected (tofi didn't exit empty)
if [ $? -eq 0 ] && [ -n "$SELECTION" ]; then
    # Switch back to the original workspace
    if [[ "$CURRENT_WORKSPACE" =~ ^[0-9]+$ ]]; then
        # It's a number (workspace index)
        niri msg action focus-workspace "$CURRENT_WORKSPACE"
    else
        # It's a workspace name
        niri msg action focus-workspace "$CURRENT_WORKSPACE"
    fi
fi