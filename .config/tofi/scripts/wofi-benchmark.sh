#!/bin/bash

# Wofi Performance Benchmark Script

echo "🚀 Wofi vs Tofi Performance Comparison"
echo "======================================"

# Function to measure launcher spawn time
measure_launcher() {
    local launcher="$1"
    local mode="$2"
    local iterations="$3"
    local total_time=0
    
    echo "Testing $launcher $mode ($iterations iterations)..."
    
    for i in $(seq 1 $iterations); do
        start_time=$(date +%s%N)
        
        if [ "$launcher" = "wofi" ]; then
            # Test wofi
            echo "" | timeout 0.1s wofi --show "$mode" --prompt "Benchmark $i" >/dev/null 2>&1
        elif [ "$launcher" = "tofi" ]; then
            # Test tofi
            if [ "$mode" = "drun" ]; then
                echo "" | timeout 0.1s tofi-drun --prompt-text "Benchmark $i" >/dev/null 2>&1
            else
                echo "" | timeout 0.1s tofi-run --prompt-text "Benchmark $i" >/dev/null 2>&1
            fi
        fi
        
        end_time=$(date +%s%N)
        iteration_time=$((end_time - start_time))
        total_time=$((total_time + iteration_time))
        
        printf "."
    done
    
    echo ""
    avg_time_ns=$((total_time / iterations))
    avg_time_ms=$((avg_time_ns / 1000000))
    
    echo "Average spawn time: ${avg_time_ms}ms"
    echo ""
    
    # Return the average time for comparison
    echo $avg_time_ms
}

# System info
echo "System Information:"
echo "CPU: $(lscpu | grep 'Model name' | sed 's/.*: *//')"
echo "Wofi: $(wofi --version)"
echo "Tofi: $(tofi --help 2>&1 | head -1)"
echo ""

# Run benchmarks
echo "📊 Performance Tests:"
echo ""

# Test application launchers
tofi_drun_time=$(measure_launcher "tofi" "drun" 5)
wofi_drun_time=$(measure_launcher "wofi" "drun" 5)

# Test run modes
tofi_run_time=$(measure_launcher "tofi" "run" 5)
wofi_run_time=$(measure_launcher "wofi" "run" 5)

echo "🏁 Results Summary:"
echo "=================="
echo "Application Launcher (drun):"
echo "  • Tofi:  ${tofi_drun_time}ms"
echo "  • Wofi:  ${wofi_drun_time}ms"
echo ""
echo "Command Runner:"
echo "  • Tofi:  ${tofi_run_time}ms" 
echo "  • Wofi:  ${wofi_run_time}ms"
echo ""

# Determine winners
if [ "$tofi_drun_time" -lt "$wofi_drun_time" ]; then
    drun_winner="Tofi"
    drun_diff=$((wofi_drun_time - tofi_drun_time))
else
    drun_winner="Wofi"
    drun_diff=$((tofi_drun_time - wofi_drun_time))
fi

if [ "$tofi_run_time" -lt "$wofi_run_time" ]; then
    run_winner="Tofi"
    run_diff=$((wofi_run_time - tofi_run_time))
else
    run_winner="Wofi"
    run_diff=$((tofi_run_time - wofi_run_time))
fi

echo "🏆 Performance Winners:"
echo "App Launcher: $drun_winner (${drun_diff}ms faster)"
echo "Command Runner: $run_winner (${run_diff}ms faster)"
echo ""
echo "💡 Notes:"
echo "• Tofi: Minimal, fast, no icons"
echo "• Wofi: GTK-based, categories, icons"