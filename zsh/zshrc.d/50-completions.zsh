# Docker CLI completions (cached compinit)
[ -d "$HOME/.docker/completions" ] && fpath=("$HOME/.docker/completions" $fpath)

autoload -Uz compinit
compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"

# bun completions
[ -s "$HOME/.bun/_bun" ] && . "$HOME/.bun/_bun"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
