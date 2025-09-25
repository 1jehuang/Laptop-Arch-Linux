#!/bin/bash

# Simple calculator using tofi
result=$(tofi --prompt-text "Calculate: " --require-match false)

if [ -n "$result" ]; then
    # Calculate and show result
    answer=$(echo "$result" | bc -l 2>/dev/null)
    if [ -n "$answer" ]; then
        echo "$result = $answer" | tofi --prompt-text "Result: "
    fi
fi