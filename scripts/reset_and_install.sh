#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: reset_and_install.sh [options] [-- [install.sh args...]]

Safely backs up existing dotfiles/configs, removes them from $TARGET_HOME (default: $HOME),
then reruns ./install.sh to restore the curated setup.

Options:
  --target-home <path>   Target home directory (default: $HOME)
  --dry-run              Show what would happen without moving files or running install.sh
  --skip-install         Skip invoking install.sh after backups
  -y, --yes              Do not prompt for confirmation
  -h, --help             Show this help message

Pass additional arguments to install.sh after a literal --.
Examples:
  ./scripts/reset_and_install.sh --dry-run
  ./scripts/reset_and_install.sh -- --dry-run --dotfiles-only
  TARGET_HOME=/some/dir ./scripts/reset_and_install.sh -y
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
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
INSTALL_SCRIPT="$REPO_ROOT/install.sh"

[[ -x "$INSTALL_SCRIPT" ]] || err "install.sh not found or not executable at $INSTALL_SCRIPT"

TARGET_HOME="${TARGET_HOME:-$HOME}"
DRY_RUN=false
SKIP_INSTALL=false
ASSUME_YES=false
INSTALL_ARGS=()

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --target-home)
      shift || err "--target-home requires a value"
      TARGET_HOME="$1"
      ;;
    --dry-run)
      DRY_RUN=true
      ;;
    --skip-install)
      SKIP_INSTALL=true
      ;;
    -y|--yes)
      ASSUME_YES=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      INSTALL_ARGS=("$@")
      break
      ;;
    *)
      err "Unknown option: $1"
      ;;
  esac
  shift
done

[[ -d "$TARGET_HOME" ]] || err "Target home $TARGET_HOME does not exist"

BACKUP_ROOT="$TARGET_HOME/.xps13archsetup-reset"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

paths_to_reset=(
  .bash_logout
  .bash_profile
  .bashrc
  .profile
  .zshrc
  .gitconfig
  .config
  .local
)

log "Preparing reset for $TARGET_HOME"
log "Backup directory: $BACKUP_DIR"

if [[ "$DRY_RUN" = true ]]; then
  log "Dry run enabled; no changes will be made"
fi

if [[ "$ASSUME_YES" = false ]]; then
  printf 'This will move existing configs from %s into %s.\n' "$TARGET_HOME" "$BACKUP_DIR"
  printf 'Continue? [y/N]: '
  read -r reply || exit 1
  case "$reply" in
    y|Y|yes|YES)
      :
      ;;
    *)
      log "Aborted by user"
      exit 0
      ;;
  esac
fi

if [[ "$DRY_RUN" = false ]]; then
  mkdir -p "$BACKUP_DIR"
fi

backup_item() {
  local relative="$1"
  local src="$TARGET_HOME/$relative"
  local dest="$BACKUP_DIR/$relative"

  if [[ ! -e "$src" ]]; then
    log "Skipping $relative (not present)"
    return
  fi

  log "Backing up $relative"
  if [[ "$DRY_RUN" = true ]]; then
    printf '      mv "%s" "%s"\n' "$src" "$dest"
    return
  fi

  mkdir -p "$(dirname -- "$dest")"
  mv "$src" "$dest"
}

for path in "${paths_to_reset[@]}"; do
  backup_item "$path"
done

if [[ "$SKIP_INSTALL" = true ]]; then
  log "Skipping install.sh as requested"
  exit 0
fi

if [[ "$DRY_RUN" = true ]]; then
  log "Dry run: would execute install.sh ${INSTALL_ARGS[*]}"
  exit 0
fi

log "Running install.sh ${INSTALL_ARGS[*]}"
( cd "$REPO_ROOT" && TARGET_HOME="$TARGET_HOME" "$INSTALL_SCRIPT" "${INSTALL_ARGS[@]}" )
log "Reset complete"
