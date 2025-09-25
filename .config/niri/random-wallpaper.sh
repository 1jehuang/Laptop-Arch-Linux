#!/bin/bash

# Array of wallpapers
wallpapers=(
    "/home/jeremy/Pictures/Wallpapers/blackhole_nasa_hires.jpg"
    "/home/jeremy/Pictures/Wallpapers/blackholewallpaper.jpeg"
)

# Wait for swww daemon to be ready
sleep 2

# Get random wallpaper
random_wallpaper=${wallpapers[$RANDOM % ${#wallpapers[@]}]}

# Set wallpaper with swww
swww img "$random_wallpaper" --transition-type fade