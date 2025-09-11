# xps13archsetup

Curated dotfiles for this Arch Linux XPS 13.

Included
- Top-level shell/editor/git configs (e.g., .zshrc, .bashrc, .gitconfig)
- Selected `.config` subdirectories for common tools (nvim, zsh, tmux, alacritty, starship, etc.)

Excluded by design (sensitive/volatile)
- .ssh/, .gnupg/, .pki/, .local/, .cache/
- Browser profiles (.config/chromium, .config/google-chrome, .mozilla, etc.)
- Secrets, credentials, and key material if detected

If you want additional apps/configs included, let’s add them intentionally.

## Packages
- `packages/pacman-explicit-native.txt`: explicitly installed native packages
- `packages/pacman-explicit-foreign.txt`: explicitly installed foreign (AUR/manual) packages
- `packages/pacman-all-installed.txt`: all installed packages (reference)

## Desktop Files
- User-local `.desktop` files copied from `~/.local/share/applications`.
- System `.desktop` files are not copied; see `manifests/system-desktop-files.txt` for a list.

Note: `.local/` is generally excluded, but `~/.local/share/applications/*.desktop` is included intentionally for user overrides.

## Desktop Setup Coverage
Included beyond shell/editor configs:
- Wayland/desktop configs: niri, waybar, swayidle/lock, wlogout, wofi/rofi, dunst/mako, kanshi
- Portals and input methods: xdg-desktop-portal*, fcitx5
- Theming: gtk-3.0/gtk-4.0, qt5ct/qt6ct, Kvantum (settings only)
- Autostart: `.config/autostart/*.desktop`
- User services: `.config/systemd/user/*` + manifests of enabled timers/services
- MIME defaults: `mimeapps.list` (user + local)
- Assets: wallpapers copied to `assets/Wallpapers/` if reasonably sized, otherwise a manifest

Large binary themes/icons are not vendored by default; add them explicitly if required or use package sources.
