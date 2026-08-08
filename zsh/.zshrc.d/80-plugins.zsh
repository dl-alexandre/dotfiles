# Interactive plugins. Heavy ones defer until first prompt (zle -N precmd).

# fzf keybindings + completion (Homebrew) — cheap
if [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]; then
  . /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi
if [ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]; then
  . /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# Atuin — after plain hist opts; relatively cheap init
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

  # Syntax highlighting MUST be last among ZLE-touching plugins
  if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    . /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
}
precmd_functions=(_zsh_load_interactive_plugins $precmd_functions)
