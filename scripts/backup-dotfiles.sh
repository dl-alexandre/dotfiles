#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMMIT_MESSAGE="Auto backup: $(date '+%Y-%m-%d %H:%M:%S')"

notify() {
  if command -v notify-send &>/dev/null; then
    notify-send "Dotfiles Backup" "$1"
  fi
}

cd "$DOTFILES_DIR"

# Check if there are changes
if ! git diff-index --quiet HEAD --; then
  echo "Changes detected, committing..."
  git add -A
  git commit -m "$COMMIT_MESSAGE"
else
  echo "No changes to commit."
  notify "No changes to backup"
  exit 0
fi

# Push to remote
if ! git push origin "$(git rev-parse --abbrev-ref HEAD)"; then
  notify "Backup failed: could not push to GitHub"
  echo "Error: Failed to push to GitHub"
  exit 1
fi

echo "✓ Dotfiles backed up successfully"
notify "Weekly backup complete ✓"
