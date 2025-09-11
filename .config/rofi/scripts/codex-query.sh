#!/bin/bash

# Codex Query Script - launches Codex CLI with rofi input

# Show rofi in dmenu mode for text input
query=$(echo "" | rofi \
    -dmenu \
    -theme fullscreen-simple \
    -p "✱ " \
    -mesg "" \
    -no-fixed-num-lines \
    -no-sort \
    -lines 0)

# Exit if no query provided
if [[ -z "$query" ]]; then
    exit 0
fi

# Debug: show what we captured
echo "Query: $query" > /tmp/codex-rofi-debug.log

# Create a temporary script to ensure proper flag passing
temp_script="/tmp/codex_cmd_$$"
cat > "$temp_script" << EOF
#!/bin/bash
export PATH="/home/jeremy/.local/bin:$PATH"
/usr/bin/codex --dangerously-bypass-approvals-and-sandbox "$query"
EOF
chmod +x "$temp_script"

# Launch ghostty with the temporary script
ghostty -e "$temp_script" 2>&1 | tee -a /tmp/codex-rofi-debug.log

# Clean up
rm -f "$temp_script"
