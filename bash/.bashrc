# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
#
# Use VSCode instead of neovim as your default editor
# export EDITOR="code"
#
# Set a custom prompt with the directory revealed (alternatively use https://starship.rs)
# PS1="\W \[\e]0;\w\a\]$PS1"










# Double-ESC: fetch previous command, prepend sudo, execute immediately
# \e\e = press Esc twice.
# \C-p = recall previous history entry into the current line.
# \C-a = move cursor to start of line.
# sudo = the text inserted.
# \C-e = move to end of line.
bind '"\e\e":"\C-p\C-a sudo \C-e"'


# amp
export PATH="$HOME/.local/bin:$PATH"

