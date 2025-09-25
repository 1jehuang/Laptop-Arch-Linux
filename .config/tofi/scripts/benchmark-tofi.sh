#!/bin/bash

# Tofi Performance Benchmark Script

echo "🚀 Tofi Performance Benchmark"
echo "=============================="

# Function to measure tofi spawn time
measure_spawn() {
    local mode="$1"
    local iterations="$2"
    local total_time=0
    
    echo "Testing $mode ($iterations iterations)..."
    
    for i in $(seq 1 $iterations); do
        # Measure time to spawn and immediately exit tofi
        start_time=$(date +%s%N)
        
        # Spawn tofi and immediately send Escape to close it
        (sleep 0.01 && niri msg action toggle-keyboard-shortcuts-inhibit) &
        timeout 2s $mode --prompt-text "Benchmark $i" >/dev/null 2>&1 &
        tofi_pid=$!
        
        # Wait a tiny bit for tofi to appear, then kill it
        sleep 0.02
        kill $tofi_pid 2>/dev/null
        wait $tofi_pid 2>/dev/null
        
        end_time=$(date +%s%N)
        iteration_time=$((end_time - start_time))
        total_time=$((total_time + iteration_time))
        
        # Show progress
        printf "."
    done
    
    echo ""
    avg_time_ns=$((total_time / iterations))
    avg_time_ms=$((avg_time_ns / 1000000))
    
    echo "Average spawn time: ${avg_time_ms}ms (${avg_time_ns}ns)"
    echo ""
}

# Function to measure with hyperfine if available
measure_with_hyperfine() {
    if command -v hyperfine >/dev/null 2>&1; then
        echo "📊 Using hyperfine for precise measurement:"
        echo "tofi-drun:"
        hyperfine --warmup 3 --min-runs 10 'echo | tofi-drun --prompt-text "Benchmark" >/dev/null 2>&1' 2>/dev/null || echo "Failed to run hyperfine test"
        echo ""
    else
        echo "💡 Install 'hyperfine' for more precise benchmarking: pacman -S hyperfine"
        echo ""
    fi
}

# System info
echo "System Information:"
echo "CPU: $(lscpu | grep 'Model name' | sed 's/.*: *//')"
echo "Tofi: $(tofi --help 2>&1 | head -1)"
echo "Current theme: $(if grep -q 'horizontal = true' ~/.config/tofi/config; then echo 'soy-milk'; else echo 'fullscreen'; fi)"
echo ""

# Basic measurements
measure_spawn "tofi-drun" 5
measure_spawn "tofi-run" 5

# Hyperfine measurement
measure_with_hyperfine

echo "🎯 tofi GitHub claims: 2ms ideal, 4ms dmenu-style, 17-28ms fullscreen"
echo "Your results compared to their Ryzen 5 5600U benchmarks above ⬆️"