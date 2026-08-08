# Prompt + directory jumper (guarded so missing bins never break shell init).
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  PS1='%n@%m %1~ %# '
fi

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
