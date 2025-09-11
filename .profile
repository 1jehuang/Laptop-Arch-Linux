# Wayland environment setup for login
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=niri
export XDG_SESSION_DESKTOP=niri
export WAYLAND_DISPLAY=wayland-1
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export NIXOS_OZONE_WL=1

# Ensure Wayland socket exists
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-0}
fi
