#!/bin/bash

# Get current workspace ID and active window
workspace_id=$(hyprctl activeworkspace -j | jq '.id')
active_window=$(hyprctl activewindow -j | jq -r '.address')

# Get window position and total count
result=$(hyprctl clients -j | jq -r --argjson ws "$workspace_id" '
  map(select(.workspace.id == $ws)) | 
  sort_by(.at[0]) | 
  to_entries | 
  {
    position: (map(select(.value.address == "'$active_window'")) | .[0].key + 1 // 0),
    total: length
  } |
  if .position > 0 then "\(.position)/\(.total)" else "" end
')

if [ -n "$result" ]; then
  echo "󰖲 $result"
else
  echo ""
fi