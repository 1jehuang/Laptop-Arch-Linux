# Wayland environment variables for GUI apps
export WAYLAND_DISPLAY=wayland-1
export XDG_SESSION_TYPE=wayland
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1

# Browser aliases with Wayland support
alias chrome="google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland"
alias chromium="chromium --ozone-platform=wayland --enable-features=UseOzonePlatform"

# WiFi login aliases  
alias wifilogin="node /home/jeremy/francis-court-wifi-automation/wifi_login_playwright.js"
alias wifiheadless="/home/jeremy/francis-court-wifi-automation/wifi_login_headless.sh"

# Volume control function
volumeset() {
    pactl set-sink-volume @DEFAULT_SINK@ "$1%"
}

# Auto-start niri on tty1
if [ "$(tty)" = "/dev/tty1" ]; then
    exec niri-session
fi
# opencode
export PATH=/home/jeremy/.opencode/bin:$PATH
alias code="code --enable-features=UseOzonePlatform --ozone-platform=wayland"

# CoppeliaSim Environment Variables  
export COPPELIASIM_ROOT=${HOME}/CoppeliaSim
export QT_QPA_PLATFORM_PLUGIN_PATH=$COPPELIASIM_ROOT
alias coppeliasim="LD_LIBRARY_PATH=\"$COPPELIASIM_ROOT\" QT_QPA_PLATFORM_PLUGIN_PATH=\"$COPPELIASIM_ROOT\" \"$COPPELIASIM_ROOT/coppeliaSim.sh\""


# Cursor editor alias with Wayland support
alias cursor="/home/jeremy/.local/bin/cursor-launcher"
