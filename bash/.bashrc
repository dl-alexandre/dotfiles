# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

. "$HOME/.local/bin/env"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/developer/.lmstudio/bin"
# End of LM Studio CLI section

. "$HOME/.cargo/env"

# Double-ESC: fetch previous command, prepend sudo, execute immediately
# \e\e = press Esc twice.
# \C-p = recall previous history entry into the current line.
# \C-a = move cursor to start of line.
# sudo = the text inserted.
# \C-e = move to end of line.
bind '"\e\e":"\C-p\C-a sudo \C-e"'


# amp
export PATH="$HOME/.local/bin:$PATH"
export TERM=xterm
