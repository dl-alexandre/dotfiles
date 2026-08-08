#!/bin/bash
# Install dotfiles using GNU Stow (prefer Homebrew stow on macOS).

set -euo pipefail
shopt -s nullglob

# Prefer a working stow — ~/.local/bin/stow may be a broken partial install.
if [[ -x /opt/homebrew/bin/stow ]]; then
  STOW=/opt/homebrew/bin/stow
elif command -v stow >/dev/null 2>&1; then
  STOW="$(command -v stow)"
else
  echo "Error: stow is not installed. On macOS: brew install stow" >&2
  exit 1
fi

usage() {
  echo "Usage: $0 [install|uninstall]"
  echo "  install   - Stow dotfiles (default)"
  echo "  uninstall - Unstow dotfiles"
  exit 1
}

ACTION="install"
if [[ $# -gt 0 ]]; then
  case $1 in
    install) ACTION="install" ;;
    uninstall) ACTION="uninstall" ;;
    *) usage ;;
  esac
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$OS" in
  linux*) PLATFORM="linux" ;;
  darwin*) PLATFORM="macos" ;;
  *) echo "Unknown OS: $OS"; exit 1 ;;
esac

PACKAGES=()
for dir in */; do
  dir=${dir%/}
  if [[ -d "$dir" && ! "$dir" =~ ^\. && "$dir" != "scripts" && "$dir" != "agents-md" && "$dir" != "stow-2.4.0" ]]; then
    PACKAGES+=("$dir")
  fi
done
PACKAGES+=("scripts")

if [[ "$ACTION" == "install" ]]; then
  echo "Installing dotfiles from $DOTFILES_DIR (stow=$STOW)..."
  echo "Platform detected: $PLATFORM"
  echo "Packages to install: ${PACKAGES[*]}"
  STOW_ARGS=(--restow --adopt)
else
  echo "Uninstalling dotfiles from $DOTFILES_DIR..."
  echo "Platform: $PLATFORM"
  echo "Packages to uninstall: ${PACKAGES[*]}"
  STOW_ARGS=(--delete)
fi

cd "$DOTFILES_DIR"

for package in "${PACKAGES[@]}"; do
  if [[ -d "$package" ]]; then
    echo "Processing $package..."
    "$STOW" "${STOW_ARGS[@]}" --target "$HOME" "$package"
  else
    echo "Warning: Directory $package not found, skipping."
  fi
done

if [[ -d "agents-md/$PLATFORM" ]]; then
  echo "Processing agents-md/$PLATFORM (home folder)..."
  "$STOW" "${STOW_ARGS[@]}" --target "$HOME" -d "$DOTFILES_DIR/agents-md" "$PLATFORM"

  if [[ -f "agents-md/$PLATFORM/opencode/AGENTS.md" ]]; then
    echo "Processing agents-md/$PLATFORM/opencode (OpenCode config)..."
    mkdir -p "$HOME/.config/opencode"
    "$STOW" "${STOW_ARGS[@]}" --target "$HOME/.config/opencode" -d "$DOTFILES_DIR/agents-md/$PLATFORM" opencode
  fi
else
  echo "Warning: agents-md/$PLATFORM not found, skipping AGENTS.md"
fi

if [[ "$ACTION" == "install" && "$OSTYPE" == "darwin"* ]]; then
  if command -v mise >/dev/null 2>&1; then
    echo "Installing mise tools from config..."
    mise install
  else
    echo "Skipping mise tools (mise not found — brew install mise)"
  fi

  if command -v brew >/dev/null 2>&1; then
    if ! brew tap 2>/dev/null | grep -qx 'homebrew/autoupdate'; then
      echo "Tapping homebrew/autoupdate..."
      brew tap homebrew/autoupdate || true
    fi
    if ! brew autoupdate status 2>/dev/null | grep -q 'is installed and running'; then
      echo "Starting brew autoupdate (daily upgrade+cleanup; covers mise)..."
      brew autoupdate start 86400 --upgrade --cleanup || true
    fi
  fi

  if command -v npm >/dev/null 2>&1; then
    echo "Installing npm global tools (tldr)..."
    npm install -g tldr || true
  fi
fi

echo "Operation completed successfully!"
