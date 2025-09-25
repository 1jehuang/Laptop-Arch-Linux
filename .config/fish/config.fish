# Auto-start niri if logging in on tty1 and not already in a session
if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
    exec niri --session
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting ""
    
    function volumeset
        pactl set-sink-volume @DEFAULT_SINK@ "$argv[1]%"
    end
    
    # Browser aliases with Wayland support
    alias chrome="google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland"
    alias chromium="chromium --ozone-platform=wayland --enable-features=UseOzonePlatform"
    
    # WiFi login aliases
    alias wifilogin="node /home/jeremy/francis-court-wifi-automation/wifi_login_playwright.js"
    alias wifiheadless="/home/jeremy/francis-court-wifi-automation/wifi_login_headless.sh"
    
    # Waybar launch with proper environment
    alias start-waybar="env WAYLAND_DISPLAY=wayland-0 XDG_SESSION_TYPE=wayland waybar"
    
    # Wayland environment variables for GUI apps - use global export
    set -gx WAYLAND_DISPLAY (printenv WAYLAND_DISPLAY 2>/dev/null || echo "wayland-0")
    set -gx XDG_SESSION_TYPE wayland
    set -gx QT_QPA_PLATFORM wayland
    set -gx GDK_BACKEND wayland
    # Don't set DISPLAY for pure Wayland apps like waybar
    
    # Starship prompt (only if installed)
    if command -v starship > /dev/null
        starship init fish | source
    end
end
set -gx PATH $HOME/.local/bin $PATH
set -x TERMINAL alacritty
