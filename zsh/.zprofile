# ~/.zprofile — login shells only.
# Homebrew must be early so non-interactive login tools resolve brew.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
