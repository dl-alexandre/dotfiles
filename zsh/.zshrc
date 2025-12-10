PROMPT=''

alias src="source ~/.zshrc"
alias vzs="nvim ~/.zshrc"
alias mt="cd ~/Documents/GitHub/MILC/MilcTesting"
alias rnr="~/Documents/GitHub/MILC/SwiftAppium/actions-runner/run.sh"
alias sa="~/Documents/GitHub/MILC/SwiftAppium"
alias python="python3.13"
alias amp="amp -m free"

# --- Environment Variables and PATH Configuration ---

# **CRITICAL: Add system paths *before* NVM**
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"  # System paths first!

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
nvm use 23.10.0 > /dev/null 2>&1

# Construct the PATH - NVM's node path must come first and everything else after that
export PATH="$NVM_DIR/versions/node/v23.10.0/bin:$PATH" # NVM must be first
export NODE_HOME=$NVM_DIR/versions/node/v23.10.0
export PATH="$PATH:$NODE_HOME/bin"
export NODE_PATH="$NODE_HOME/lib/node_modules"
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$PATH:$JAVA_HOME/bin"
export ANDROID_HOME=~/Library/Android/sdk
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools"
export M2_HOME=/usr/local/apache-maven/apache-maven-3.9.9
export PATH="$PATH:$M2_HOME/bin"
export ANT_HOME=/usr/local/apache-ant/apache-ant-1.10.15
export PATH="$PATH:$ANT_HOME/bin"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

export PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.13/bin"

# --- Appium Related Aliases ---
# Removed APMLOG here

# This alias won't work due to limitations of alias. But I'll keep the intention to explain further.
# alias apm+="pgrep -f 'emulator -avd Emulator15' > /dev/null || (emulator -avd Emulator15 > /dev/null 2>&1 &) && \
# pgrep -f 'emulator -avd Emulator11' > /dev/null || (emulator -avd Emulator11 > /dev/null 2>&1 &) && \
# xcrun simctl list | grep '03AD2C17-4993-462F-93F1-5B1A38B31FB0 (Booted)' > /dev/null || (xcrun simctl boot '03AD2C17-4993-462F-93F1-5B1A38B31FB0' > /dev/null 2>&1) && \
# xcrun simctl list | grep '1C29D004-3855-49F5-B0AA-779BB6C029DD (Booted)' > /dev/null || (xcrun simctl boot '1C29D004-3855-49F5-B0AA-779BB6C029DD' > /dev/null 2>&1)"

# Use a function instead of `apm+=`, because alias does not work as intended
apm_extended() {
  APMLOG=~/Documents/Github/Milc/One/Appium/appium_$(date +%Y%m%d_%H%M%S).log # Moving APMLOG here with date command
  pgrep -f 'emulator -avd Emulator15' > /dev/null || (emulator -avd Emulator15 > /dev/null 2>&1 &)
  pgrep -f 'emulator -avd Emulator11' > /dev/null || (emulator -avd Emulator11 > /dev/null 2>&1 &)
  xcrun simctl list | grep '03AD2C17-4993-462F-93F1-5B1A38B31FB0 (Booted)' > /dev/null || (xcrun simctl boot '03AD2C17-4993-462F-93F1-5B1A38B31FB0' > /dev/null 2>&1)
  xcrun simctl list | grep '1C29D004-3855-49F5-B0AA-779BB6C029DD (Booted)' > /dev/null || (xcrun simctl boot '1C29D004-3855-49F5-B0AA-779BB6C029DD' > /dev/null 2>&1)
  appium --log-level debug --log "$APMLOG"
}
alias apm_ext="apm_extended" # calling this with apm_ext will start emulators and run apm

apm_update() {
	npm update appium && \
	appium driver update xcuitest --unsafe && \
	appium driver update uiautomator2 --unsafe && \
	appium driver update espresso --unsafe && \
	appium driver update chromium --unsafe && \
	appium driver run chromium install-chromedriver	
}

alias apmu="apm_update"

alias apm="appium --log-level warn:warn --log ~/Documents/Github/Milc/One/Appium/appium_$(date +%Y%m%d_%H%M%S).log"

alias kl+="adb -s emulator-5554 emu kill && \
adb -s emulator-5556 emu kill && \
xcrun simctl shutdown "1C29D004-3855-49F5-B0AA-779BB6C029DD" && \
xcrun simctl shutdown "03AD2C17-4993-462F-93F1-5B1A38B31FB0""

# Source .local/bin/env (keep this at the end)
. "$HOME/.local/bin/env"

# opencode
export PATH=/Users/developer/.opencode/bin:$PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/opt/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/opt/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
## <<< conda initialize <<<

bindkey -v

__sudo-replace-buffer() {
  local old=$1 new=$2 space=${2:+ }

  # if the cursor is positioned in the $old part of the text, make
  # the substitution and leave the cursor after the $new text
  if [[ $CURSOR -le ${#old} ]]; then
    BUFFER="${new}${space}${BUFFER#$old }"
    CURSOR=${#new}
  # otherwise just replace $old with $new in the text before the cursor
  else
    LBUFFER="${new}${space}${LBUFFER#$old }"
  fi
}

sudo-command-line() {
  # If line is empty, get the last run command from history
  [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

  # Save beginning space
  local WHITESPACE=""
  if [[ ${LBUFFER:0:1} = " " ]]; then
    WHITESPACE=" "
    LBUFFER="${LBUFFER:1}"
  fi

  {
    # If $SUDO_EDITOR or $VISUAL are defined, then use that as $EDITOR
    # Else use the default $EDITOR
    local EDITOR=${SUDO_EDITOR:-${VISUAL:-$EDITOR}}

    # If $EDITOR is not set, just toggle the sudo prefix on and off
    if [[ -z "$EDITOR" ]]; then
      case "$BUFFER" in
        sudo\ -e\ *) __sudo-replace-buffer "sudo -e" "" ;;
        sudo\ *) __sudo-replace-buffer "sudo" "" ;;
        *) LBUFFER="sudo $LBUFFER" ;;
      esac
      return
    fi

    # Check if the typed command is really an alias to $EDITOR

    # Get the first part of the typed command
    local cmd="${${(Az)BUFFER}[1]}"
    # Get the first part of the alias of the same name as $cmd, or $cmd if no alias matches
    local realcmd="${${(Az)aliases[$cmd]}[1]:-$cmd}"
    # Get the first part of the $EDITOR command ($EDITOR may have arguments after it)
    local editorcmd="${${(Az)EDITOR}[1]}"

    # Note: ${var:c} makes a $PATH search and expands $var to the full path
    # The if condition is met when:
    # - $realcmd is '$EDITOR'
    # - $realcmd is "cmd" and $EDITOR is "cmd"
    # - $realcmd is "cmd" and $EDITOR is "cmd --with --arguments"
    # - $realcmd is "/path/to/cmd" and $EDITOR is "cmd"
    # - $realcmd is "/path/to/cmd" and $EDITOR is "/path/to/cmd"
    # or
    # - $realcmd is "cmd" and $EDITOR is "cmd"
    # - $realcmd is "cmd" and $EDITOR is "/path/to/cmd"
    # or
    # - $realcmd is "cmd" and $EDITOR is /alternative/path/to/cmd that appears in $PATH
    if [[ "$realcmd" = (\$EDITOR|$editorcmd|${editorcmd:c}) \
      || "${realcmd:c}" = ($editorcmd|${editorcmd:c}) ]] \
      || builtin which -a "$realcmd" | command grep -Fx -q "$editorcmd"; then
      __sudo-replace-buffer "$cmd" "sudo -e"
      return
    fi

    # Check for editor commands in the typed command and replace accordingly
    case "$BUFFER" in
      $editorcmd\ *) __sudo-replace-buffer "$editorcmd" "sudo -e" ;;
      \$EDITOR\ *) __sudo-replace-buffer '$EDITOR' "sudo -e" ;;
      sudo\ -e\ *) __sudo-replace-buffer "sudo -e" "$EDITOR" ;;
      sudo\ *) __sudo-replace-buffer "sudo" "" ;;
      *) LBUFFER="sudo $LBUFFER" ;;
    esac
  } always {
    # Preserve beginning space
    LBUFFER="${WHITESPACE}${LBUFFER}"

    # Redisplay edit buffer (compatibility with zsh-syntax-highlighting)
    zle && zle redisplay # only run redisplay if zle is enabled
  }
}

zle -N sudo-command-line

# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line
bindkey -M viins '\e\e' sudo-command-line

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
export PATH="/Users/developer/.pixi/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/developer/.lmstudio/bin"
# End of LM Studio CLI section

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/developer/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

. "$HOME/.asdf/asdf.sh"
eval "$(zoxide init zsh)"
export PATH="$HOME/bin:$PATH"

# Added by Antigravity
export PATH="/Users/developer/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "/Users/developer/.bun/_bun" ] && source "/Users/developer/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
