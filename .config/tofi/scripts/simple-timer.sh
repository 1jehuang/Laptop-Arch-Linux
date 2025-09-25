#!/bin/bash

# Simple tofi spawn timer - measures time to appear on screen

echo "⏱️  Measuring tofi spawn time..."

start_time=$(date +%s%N)
# Send empty input to tofi and let it exit automatically
echo "" | timeout 0.1s tofi-drun --prompt-text "Timer Test" >/dev/null 2>&1
end_time=$(date +%s%N)

duration_ns=$((end_time - start_time))
duration_ms=$((duration_ns / 1000000))

echo "📊 Results:"
echo "Total time: ${duration_ms}ms"
echo "Compared to tofi claims:"
echo "  • Ideal case: 2ms"
echo "  • dmenu-style: ~4ms" 
echo "  • Fullscreen: 17-28ms"

if [ $duration_ms -lt 5 ]; then
    echo "🚀 Excellent! Very fast startup"
elif [ $duration_ms -lt 20 ]; then
    echo "✅ Good performance"
elif [ $duration_ms -lt 50 ]; then
    echo "⚠️  Moderate - could be optimized"
else
    echo "🐌 Slow - check your configuration"
fi