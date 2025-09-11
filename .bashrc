# Wayland environment
export WAYLAND_DISPLAY=wayland-1
export XDG_SESSION_TYPE=wayland
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export NIXOS_OZONE_WL=1

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Add Blender build to PATH
export PATH="$HOME/build_linux/bin:$PATH"

# Browser aliases with Wayland support
alias chrome="chromium --ozone-platform=wayland --enable-features=UseOzonePlatform"
alias firefox="firefox"

# VSCode with Wayland/Ozone support
alias code="code --enable-features=UseOzonePlatform --ozone-platform=wayland"

# Auto-start Niri if not running (only on tty1 and not already in a session)
if [[ -z $DISPLAY && $XDG_VTNR -eq 1 && -z $XDG_SESSION_ID ]]; then
  exec niri-session
fi

# Test Chrome/Chromium function
test_chrome() {
    echo "Testing Chromium with Wayland..."
    chromium --ozone-platform=wayland --enable-features=UseOzonePlatform --version
    echo "Chrome alias ready: type chrome to launch"
}
alias chrome='google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland'
alias wifilogin="node /home/jeremy/francis-court-wifi-automation/wifi_login_playwright.js"
alias wifiheadless="/home/jeremy/francis-court-wifi-automation/wifi_login_headless.sh"

# Volume control alias
volumeset() {
    pactl set-sink-volume @DEFAULT_SINK@ "$1%"
}
export PATH="$HOME/.cargo/bin:$PATH"
alias iphonewifi='/home/jeremy/francis-court-wifi-automation/iphone_wifi_connect.sh'
export PATH="~/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Set default editor to nvim
export EDITOR=nvim
export VISUAL=nvim
alias code="code --enable-features=UseOzonePlatform --ozone-platform=wayland"

# CoppeliaSim Environment Variables
export COPPELIASIM_ROOT=${HOME}/CoppeliaSim
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COPPELIASIM_ROOT
export QT_QPA_PLATFORM_PLUGIN_PATH=$COPPELIASIM_ROOT

export PATH="$HOME/.cargo/bin:$PATH"

# Initialize Starship prompt
eval "$(starship init bash)"
