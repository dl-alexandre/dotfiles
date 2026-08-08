# Lazy-friendly interactive plugins (load last).

# fzf keybindings + completion (Homebrew)
if [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]; then
  . /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi
if [ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]; then
  . /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# Autosuggestions
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  . /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
fi

# Atuin — magical shell history (after plain hist opts)
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# Syntax highlighting MUST be sourced last among ZLE-touching plugins
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  . /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
