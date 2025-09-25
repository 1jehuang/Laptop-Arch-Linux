#!/bin/bash
# Launch Claude in persistent Ghostty terminal

# Create a temporary script to ensure proper execution
temp_script="/tmp/claude_continue_$$"
cat > "$temp_script" << 'EOF'
#!/bin/bash
export PATH="/home/jeremy/.local/bin:$PATH"
cd /home/jeremy
/home/jeremy/.local/bin/claude --dangerously-skip-permissions --continue
exec bash
EOF
chmod +x "$temp_script"

# Launch ghostty with the temporary script
ghostty -e "$temp_script"

# Clean up
rm -f "$temp_script"