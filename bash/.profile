# POSIX login profile. Keep thin; zsh uses .zprofile/.zshrc instead.
# Intentionally no RVM / conda / LM Studio / plaintext token loads.

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
