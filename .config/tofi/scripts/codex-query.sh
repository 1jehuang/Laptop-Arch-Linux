#!/bin/bash

# Codex Query Script - launches Codex CLI with tofi input

# Show tofi using the main config (same size as drun)
query=$(tofi \
    --config ~/.config/tofi/config \
    --prompt-text "✱ " \
    --placeholder-text "" \
    --require-match false \
    --num-results 0)

# Exit if no query provided
if [[ -z "$query" ]]; then
    exit 0
fi

# Debug: show what we captured
echo "Query: $query" > /tmp/codex-debug.log

# Create a temporary script to ensure proper flag passing
temp_script="/tmp/codex_cmd_$$"
cat > "$temp_script" << EOF
#!/bin/bash
export PATH="/home/jeremy/.local/bin:$PATH"
codex --dangerously-bypass-approvals-and-sandbox "$query"
EOF
chmod +x "$temp_script"

# Launch ghostty with the temporary script
ghostty -e "$temp_script" 2>&1 | tee -a /tmp/codex-debug.log

# Clean up
rm -f "$temp_script"

