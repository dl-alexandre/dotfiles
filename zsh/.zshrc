# ~/.zshrc — interactive zsh entrypoint.
# Real config lives in .zshrc.d/* (sourced in lexical order).

# Resolve next to this file (works via stow symlink).
ZSHRC_D="${ZSHRC_D:-${${(%):-%x}:A:h}/.zshrc.d}"

if [ -d "$ZSHRC_D" ]; then
  for _zshrc_fragment in "$ZSHRC_D"/*.zsh(N); do
    . "$_zshrc_fragment"
  done
  unset _zshrc_fragment
fi
