#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: install.sh [options]

Bootstrap this repo on an Arch Linux machine. Installs packages and syncs dotfiles.

Options:
  --dotfiles-only       Only sync dotfiles; skip package installation
  --packages-only       Only install packages; skip dotfiles
  --aur-helper <name>   Explicit AUR helper to use (default: auto-detect paru/yay)
  --dry-run             Show what would happen without modifying the system
  -h, --help            Show this help message
USAGE
}

log() {
  printf '==> %s\n' "$*"
}

warn() {
  printf 'warning: %s\n' "$*" >&2
}

err() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_HOME="${TARGET_HOME:-$HOME}"

DO_DOTFILES=true
DO_PACKAGES=true
DRY_RUN=false
AUR_HELPER=""

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --dotfiles-only)
      DO_PACKAGES=false
      ;;
    --packages-only)
      DO_DOTFILES=false
      ;;
    --aur-helper)
      shift || err "--aur-helper requires a value"
      AUR_HELPER="$1"
      ;;
    --dry-run)
      DRY_RUN=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      err "Unknown option: $1"
      ;;
  esac
  shift
done

if [[ "$DO_DOTFILES" = false && "$DO_PACKAGES" = false ]]; then
  err "Nothing to do; both dotfiles and packages disabled"
fi

require_command() {
  local cmd="$1"
  local info="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    err "Required command '$cmd' not found${info:+ ($info)}"
  fi
}

install_pacman_packages() {
  local pkg_file="$SCRIPT_DIR/packages/pacman-explicit-native.txt"
  if [[ ! -f "$pkg_file" ]]; then
    warn "Missing $pkg_file; skipping pacman packages"
    return
  fi
  mapfile -t packages < <(grep -Ev '^[[:space:]]*(#|$)' "$pkg_file")
  if [[ ${#packages[@]} -eq 0 ]]; then
    log "No pacman packages listed"
    return
  fi
  if [[ "$DRY_RUN" = true ]]; then
    printf 'pacman packages to install: %s\n' "${packages[*]}"
    return
  fi
  require_command sudo
  require_command pacman
  log "Installing pacman packages (${#packages[@]})"
  sudo pacman -S --needed "${packages[@]}"
}

detect_aur_helper() {
  if [[ -n "$AUR_HELPER" ]]; then
    if ! command -v "$AUR_HELPER" >/dev/null 2>&1; then
      err "Specified AUR helper '$AUR_HELPER' not found"
    fi
    echo "$AUR_HELPER"
    return
  fi
  for helper in paru yay; do
    if command -v "$helper" >/dev/null 2>&1; then
      echo "$helper"
      return
    fi
  done
  echo ""
}

install_aur_packages() {
  local pkg_file="$SCRIPT_DIR/packages/pacman-explicit-foreign.txt"
  if [[ ! -f "$pkg_file" ]]; then
    warn "Missing $pkg_file; skipping AUR packages"
    return
  fi
  mapfile -t packages < <(grep -Ev '^[[:space:]]*(#|$)' "$pkg_file")
  if [[ ${#packages[@]} -eq 0 ]]; then
    log "No AUR packages listed"
    return
  fi
  local helper
  helper="$(detect_aur_helper)"
  if [[ -z "$helper" ]]; then
    warn "No AUR helper found (paru or yay); skipping AUR packages"
    return
  fi
  if [[ "$DRY_RUN" = true ]]; then
    printf '%s packages to install: %s\n' "$helper" "${packages[*]}"
    return
  fi
  log "Installing AUR packages (${#packages[@]}) via $helper"
  "$helper" -S --needed "${packages[@]}"
}

sync_dotfile_path() {
  local relative="$1"
  local src="$SCRIPT_DIR/$relative"
  local dest="$TARGET_HOME/$relative"
  if [[ ! -e "$src" ]]; then
    warn "Missing path $relative"
    return
  fi
  if [[ -d "$src" ]]; then
    mkdir -p "$dest"
    rsync "${RSYNC_FLAGS[@]}" "$src/" "$dest/"
  else
    mkdir -p "$(dirname -- "$dest")"
    rsync "${RSYNC_FLAGS[@]}" "$src" "$dest"
  fi
}

sync_dotfiles() {
  require_command rsync "needed to sync dotfiles"
  RSYNC_FLAGS=(-a --human-readable)
  if [[ "$DRY_RUN" = true ]]; then
    RSYNC_FLAGS+=(-n)
  else
    local backup_dir="$TARGET_HOME/.xps13archsetup-backups/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    RSYNC_FLAGS+=(--backup --backup-dir "$backup_dir")
    log "Backups for overwritten files will be stored in $backup_dir"
  fi

  local paths=(
    .bash_logout
    .bash_profile
    .bashrc
    .profile
    .zshrc
    .gitconfig
    .config
    .local
  )

  for path in "${paths[@]}"; do
    if [[ ! -e "$SCRIPT_DIR/$path" ]]; then
      continue
    fi
    log "Syncing $path"
    sync_dotfile_path "$path"
  done
}

if [[ "$DO_PACKAGES" = true ]]; then
  install_pacman_packages
  install_aur_packages
fi

if [[ "$DO_DOTFILES" = true ]]; then
  sync_dotfiles
fi

log "Done."
