# ~/.zshenv — always loaded (interactive, login, scripts). Keep minimal.
# PATH is built once in zshrc.d/00-path.zsh for interactive shells.

skip_global_compinit=1

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
