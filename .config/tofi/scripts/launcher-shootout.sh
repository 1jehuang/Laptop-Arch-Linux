#!/bin/bash

# Ultimate Launcher Performance Shootout: Tofi vs Wofi vs Rofi

echo "🚀 Ultimate Launcher Shootout"
echo "============================="

# Function to measure launcher spawn time (fixed version)
measure_launcher() {
    local launcher="$1"
    local mode="$2"
    local iterations="$3"
    local total_time=0
    
    echo -n "Testing $launcher $mode ($iterations runs): "
    
    for i in $(seq 1 $iterations); do
        start_time=$(date +%s%N)
        
        case "$launcher" in
            "tofi")
                if [ "$mode" = "drun" ]; then
                    echo "" | timeout 0.1s tofi-drun --prompt-text "Test" >/dev/null 2>&1
                else
                    echo "" | timeout 0.1s tofi-run --prompt-text "Test" >/dev/null 2>&1
                fi
                ;;
            "wofi")
                echo "" | timeout 0.1s wofi --show "$mode" --prompt "Test" >/dev/null 2>&1
                ;;
            "rofi")
                echo "" | timeout 0.1s rofi -show "$mode" -p "Test" >/dev/null 2>&1
                ;;
        esac
        
        end_time=$(date +%s%N)
        iteration_time=$((end_time - start_time))
        total_time=$((total_time + iteration_time))
        
        printf "."
    done
    
    avg_time_ns=$((total_time / iterations))
    avg_time_ms=$((avg_time_ns / 1000000))
    
    echo " ${avg_time_ms}ms"
    echo $avg_time_ms
}

# System info
echo "System: $(lscpu | grep 'Model name' | sed 's/.*: *//')"
echo "Tofi: $(tofi --help 2>&1 | head -1 | cut -d' ' -f2)"
echo "Wofi: $(wofi --version)"
echo "Rofi: $(rofi -version | head -1)"
echo ""

# Run application launcher tests
echo "📱 Application Launcher Performance:"
tofi_drun=$(measure_launcher "tofi" "drun" 5)
wofi_drun=$(measure_launcher "wofi" "drun" 5)
rofi_drun=$(measure_launcher "rofi" "drun" 5)

echo ""
echo "💻 Command Runner Performance:"
tofi_run=$(measure_launcher "tofi" "run" 5)
wofi_run=$(measure_launcher "wofi" "run" 5)
rofi_run=$(measure_launcher "rofi" "run" 5)

echo ""
echo "🏆 RESULTS SUMMARY"
echo "=================="
printf "%-20s %-15s %-15s\n" "Launcher" "App Launch" "Command Run"
printf "%-20s %-15s %-15s\n" "--------" "-----------" "-----------"
printf "%-20s %-15s %-15s\n" "Tofi" "${tofi_drun}ms" "${tofi_run}ms"
printf "%-20s %-15s %-15s\n" "Wofi" "${wofi_drun}ms" "${wofi_run}ms"
printf "%-20s %-15s %-15s\n" "Rofi" "${rofi_drun}ms" "${rofi_run}ms"

echo ""
echo "🎯 LAUNCHER COMPARISON"
echo "====================="
echo "Tofi:  ⚡ Fastest startup, minimal, great themes"
echo "Wofi:  🎨 GTK styling, categories, icons"  
echo "Rofi:  🔧 Most features, plugins, window switching"

# Find the fastest
echo ""
echo "🥇 PERFORMANCE WINNERS:"

# App launcher winner
if [ "$tofi_drun" -le "$wofi_drun" ] && [ "$tofi_drun" -le "$rofi_drun" ]; then
    echo "App Launcher: Tofi (${tofi_drun}ms)"
elif [ "$wofi_drun" -le "$rofi_drun" ]; then
    echo "App Launcher: Wofi (${wofi_drun}ms)"
else
    echo "App Launcher: Rofi (${rofi_drun}ms)"
fi

# Command runner winner
if [ "$tofi_run" -le "$wofi_run" ] && [ "$tofi_run" -le "$rofi_run" ]; then
    echo "Command Runner: Tofi (${tofi_run}ms)"
elif [ "$wofi_run" -le "$rofi_run" ]; then
    echo "Command Runner: Wofi (${wofi_run}ms)"
else
    echo "Command Runner: Rofi (${rofi_run}ms)"
fi