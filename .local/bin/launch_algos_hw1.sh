#!/usr/bin/env bash
set -euo pipefail

# Add/switch to a new empty workspace in niri (best-effort)
if command -v niri >/dev/null 2>&1; then
  # Focus a very high index to reliably land on the bottommost empty workspace
  niri msg action focus-workspace 999 >/dev/null 2>&1 || true
  # Give niri a moment to switch workspaces before spawning
  sleep 0.1
fi

# PDF to open
PDF_PATH="$HOME/cse421-algos-homework1/pset1_solution.pdf"

# If the expected path is missing, try a quick fallback search
if [[ ! -f "$PDF_PATH" ]]; then
  FOUND=$(find "$HOME" -type f \( -iname "*pset*1*.pdf" -o -iname "*hw*1*.pdf" -o -iname "*homework*1*.pdf" -o -iname "*algo*1*.pdf" \) 2>/dev/null | head -n 1 || true)
  if [[ -n "${FOUND:-}" ]]; then
    PDF_PATH="$FOUND"
  fi
fi

# Determine target working directory for terminal
TARGET_DIR="$HOME"
if [[ -f "$PDF_PATH" ]]; then
  TARGET_DIR="$(dirname "$PDF_PATH")"
fi

# Open the PDF on the newly focused workspace
if [[ -f "$PDF_PATH" ]]; then
  if command -v niri >/dev/null 2>&1; then
    niri msg action spawn -- xdg-open "$PDF_PATH" >/dev/null 2>&1 || true
  elif command -v xdg-open >/dev/null 2>&1; then
    setsid -f xdg-open "$PDF_PATH" >/dev/null 2>&1 || true
  fi
fi

launch_terminal_in_dir() {
  local dir="$1"
  if ! command -v alacritty >/dev/null 2>&1; then
    echo "Error: alacritty not found in PATH" >&2
    exit 1
  fi
  if command -v niri >/dev/null 2>&1; then
    niri msg action spawn -- alacritty --working-directory "$dir" >/dev/null 2>&1 &
  else
    setsid -f alacritty --working-directory "$dir" >/dev/null 2>&1 &
  fi
}

launch_terminal_in_dir "$TARGET_DIR"

exit 0
