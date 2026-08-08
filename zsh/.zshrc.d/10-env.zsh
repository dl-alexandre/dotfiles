# Interactive environment (non-PATH).

# Ghostty over SSH: avoid broken backspace/keys
export TERM="${TERM:-xterm-256color}"
[[ "$TERM" == "ghostty" || "$TERM_PROGRAM" == "ghostty" ]] && export TERM=xterm-256color

export CLAUDECODE=0

# mise — single version manager (node, elixir, erlang, neovim, java, …)
# Activate after 00-path so mise can prepend runtime bins ahead of Homebrew.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Optional personal overrides / secrets (never commit)
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"

# Casein DevIDE MCP token — macOS Keychain only (account=$USER, service=casein-api-token)
if [ -z "${CASEIN_API_TOKEN:-}" ]; then
  CASEIN_API_TOKEN="$(security find-generic-password -a "$USER" -s casein-api-token -w 2>/dev/null)" || true
  export CASEIN_API_TOKEN
fi
