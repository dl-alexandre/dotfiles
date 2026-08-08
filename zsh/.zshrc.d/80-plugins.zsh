# Interactive plugins. Heavy ones defer until first prompt.

# fzf keybindings + completion (Homebrew) — cheap
if [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]; then
  . /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi
if [ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]; then
  . /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# direnv — per-project env
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Atuin — after plain hist opts
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# Autosuggestions + syntax highlighting: load once on first prompt
_zsh_load_interactive_plugins() {
  unset -f _zsh_load_interactive_plugins
  precmd_functions=(${precmd_functions:#_zsh_load_interactive_plugins})

  if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  fi

  if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    . /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
}
precmd_functions=(_zsh_load_interactive_plugins $precmd_functions)
