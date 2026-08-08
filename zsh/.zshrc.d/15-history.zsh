# History — large, shared, deduped. Atuin (80-plugins) layers on top when present.
HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
HISTSIZE=100000
SAVEHIST=100000

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
