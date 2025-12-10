
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

. "$HOME/.local/bin/env"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/developer/.lmstudio/bin"
# End of LM Studio CLI section

. "$HOME/.cargo/env"
