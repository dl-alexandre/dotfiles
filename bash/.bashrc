# Thin bashrc — zsh is the primary interactive shell.

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# mise — single version manager (when bash is used interactively)
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

# npm global prefix (shared across node versions)
[ -d "$HOME/.local/share/npm-global/bin" ] && PATH="$HOME/.local/share/npm-global/bin:$PATH" && export PATH

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"

# Double-ESC: fetch previous command, prepend sudo
bind '"\e\e":"\C-p\C-a sudo \C-e"'

command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"
