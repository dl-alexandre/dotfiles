#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMMIT_MESSAGE="Auto backup: $(date '+%Y-%m-%d %H:%M:%S')"
CURRENT_BRANCH="$(git -C "$DOTFILES_DIR" rev-parse --abbrev-ref HEAD)"
UPSTREAM_REF="origin/${CURRENT_BRANCH}"
needs_push=false

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
  needs_push=true
else
  echo "No changes to commit."
fi

# Determine if there are commits that still need to be pushed
if git rev-parse --verify "$UPSTREAM_REF" &>/dev/null; then
  if [[ "$(git rev-parse HEAD)" != "$(git rev-parse "$UPSTREAM_REF")" ]]; then
    needs_push=true
  fi
else
  echo "Upstream $UPSTREAM_REF not found locally; will push to create it."
  needs_push=true
fi

if [[ "$needs_push" == false ]]; then
  echo "Nothing new to push."
  notify "No changes to backup"
  exit 0
fi

# Pull and rebase to sync with remote
if [[ "$needs_push" == true ]]; then
  if ! git pull --rebase origin "$CURRENT_BRANCH"; then
    notify "Backup failed: could not pull from GitHub"
    echo "Error: Failed to pull from GitHub"
    exit 1
  fi
fi

# Push to remote
if ! git push origin "$CURRENT_BRANCH"; then
  notify "Backup failed: could not push to GitHub"
  echo "Error: Failed to push to GitHub"
  exit 1
fi

echo "✓ Dotfiles backed up successfully"
notify "Weekly backup complete ✓"
