# Tmux Dev Layout — editor + terminal + (optional) AI pane(s)
# Usage: tdl [<ai> [<ai2>]]
tdl() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }
  local current_dir="${PWD}"
  local editor="${EDITOR:-nvim}"
  local ai="$1"
  local ai2="$2"
  local editor_pane="$TMUX_PANE"
  local ai_pane ai2_pane

  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"

  if [[ -n $ai ]]; then
    ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai_pane" "source ~/.config/tmux/tmux-pane-notify 2>/dev/null; tmux_notify_working 'starting ${ai}'" C-m
    if [[ -n $ai2 ]]; then
      ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
      tmux send-keys -t "$ai2_pane" "source ~/.config/tmux/tmux-pane-notify 2>/dev/null; tmux_notify_working 'starting ${ai2}'" C-m
      tmux send-keys -t "$ai2_pane" "$ai2" C-m
    fi
    tmux send-keys -t "$ai_pane" "$ai" C-m
  fi

  tmux send-keys -t "$editor_pane" "$editor ." C-m
  tmux select-pane -t "$editor_pane"
}

# Multi-subdir tdl: one window per subdirectory in current dir
# Usage: tdlm [<ai> [<ai2>]]
tdlm() {
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdlm."; return 1; }
  local ai="$1" ai2="$2" base_dir="$PWD" first=true
  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"
  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    local dirpath="${dir%/}"
    if $first; then
      tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tdl $ai $ai2" C-m
      first=false
    else
      local pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
    fi
  done
}

# Tmux Swarm Layout — N tiled panes all running the same command
# Usage: tsl <pane_count> <command>
tsl() {
  [[ -z $1 || -z $2 ]] && { echo "Usage: tsl <pane_count> <command>"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tsl."; return 1; }
  local count="$1" cmd="$2" current_dir="${PWD}"
  local -a panes
  panes+=("$TMUX_PANE")
  while (( ${#panes[@]} < count )); do
    local new_pane
    new_pane=$(tmux split-window -h -t "${panes[-1]}" -c "$current_dir" -P -F '#{pane_id}')
    panes+=("$new_pane")
    tmux select-layout -t "${panes[0]}" tiled
  done
  for pane in "${panes[@]}"; do
    if [[ "$cmd" =~ (claude|codex|gemini|aider|continue) ]]; then
      tmux send-keys -t "$pane" "source ~/.config/tmux/tmux-pane-notify 2>/dev/null; tmux_notify_working 'swarm: ${cmd}'" C-m
    fi
    tmux send-keys -t "$pane" "$cmd" C-m
  done
  tmux select-pane -t "${panes[0]}"
}

t-mark-remote() {
  local pane_only=0
  if [[ "$1" == "-p" ]]; then
    pane_only=1
    shift
  fi
  local cmd="${1:?usage: t-mark-remote [-p] 'ssh host-or-command'}"
  [ -z "$TMUX" ] && { echo "not in tmux"; return 1; }

  if [[ $pane_only -eq 1 ]]; then
    tmux set-option -p @is_remote 1
    tmux set-option -p @remote_cmd "$cmd"
    echo "marked current pane as remote: $cmd"
  else
    tmux set-option @is_remote 1
    tmux set-option @remote_cmd "$cmd"
    echo "marked session as remote: $cmd"
  fi
}

t-remote-reconnect() {
  [ -z "$TMUX" ] && { echo "not in tmux"; return 1; }
  ~/.local/bin/tmux-maybe-remote --force
}

t() {
  if [ "$1" = "a" ]; then
    local dir_name="${$(basename "$PWD")//./_}"
    if tmux has-session -t="$dir_name" 2>/dev/null; then
      [ -n "$TMUX" ] && tmux switch-client -t "$dir_name" || tmux attach -t "$dir_name"
    elif [ -n "$TMUX" ]; then
      tmux switch-client -l 2>/dev/null || tmux choose-tree -Zs -O time
    else
      tmux attach 2>/dev/null || { echo "no tmux sessions"; return 1; }
    fi
    return 0
  fi
  if [ "$1" = "r" ]; then
    ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh
    return 0
  fi
  if [ "$1" = "w" ]; then
    ~/.tmux/plugins/tmux-resurrect/scripts/save.sh
    return 0
  fi
  if [ "$1" = "i" ]; then
    echo "sessions"
    tmux list-sessions -F "  #{session_name}  #{session_windows}w  #{session_attached_list}" 2>/dev/null
    echo ""
    echo "resurrect saves"
    local save_dir="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect"
    local last_save=$(ls -t "$save_dir"/tmux_resurrect_*.txt 2>/dev/null | head -1)
    if [ -n "$last_save" ]; then
      local save_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$last_save")
      echo "  last save:  $save_time"
      echo "  total saves: $(ls "$save_dir"/tmux_resurrect_*.txt 2>/dev/null | wc -l | tr -d ' ')"
    else
      echo "  no saves found"
    fi
    return 0
  fi
  if [ "$1" = "s" ]; then
    if [ -n "$TMUX" ]; then
      tmux choose-tree -Zs -O time
    else
      local pick
      pick=$(tmux list-sessions -F '#S' 2>/dev/null | fzf --reverse) || return
      tmux attach -t "$pick"
    fi
    return 0
  fi
  if [ "$1" = "-l" ]; then
    print -l \
      "  mm    -> ssh milcmini-remote    (macOS)" \
      "  ts    -> ssh testserver-remote  (Linux)" \
      "  ip    -> ssh ideapad-remote     (Linux)" \
      "  ox    -> ssh optiplex-xe2-local (Linux)" \
      "  cm    -> ssh creamery_mini      (macOS)" \
      "  mira  -> ssh mira_main          (Linux)" \
      "  <host>-> ssh <host> if in ~/.ssh/config" \
      "  <any> -> plain session"
    return 0
  fi
  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    cat <<'HELP'
t — tmux session launcher
=========================

USAGE
  t              Attach/create session named after current directory
  t <name>       Attach/create session <name>
  t a            Attach to most recent session (or picker if none)
  t i            Show session info and last resurrect save time
  t r            Restore sessions from latest tmux-resurrect save
  t w            Save current sessions via tmux-resurrect
  t s            Open session picker (choose-tree inside tmux, fzf outside)
  t -l           List remote shortcuts
  t -h           This help

REMOTE SHORTCUTS (auto-ssh on creation)
  mm    -> ssh milcmini-remote    (macOS)
  ts    -> ssh testserver-remote  (Linux)
  ip    -> ssh ideapad-remote     (Linux)
  ox    -> ssh optiplex-xe2-local (Linux)
  cm    -> ssh creamery_mini      (macOS)
  mira  -> ssh mira_main          (Linux)
  Any name matching a Host entry in ~/.ssh/config also auto-ssh's.

RELATED COMMANDS
  t-mark-remote "ssh host"   Flag the CURRENT session as remote (default)
  t-mark-remote -p "ssh host" Flag ONLY the current PANE as remote (mixed local/remote)
  t-remote-reconnect         Re-send the ssh command in current pane (after drop)
  tdl [ai] [ai2]             Dev layout: editor + terminal + optional AI pane(s)
  tdlm [ai] [ai2]            Run tdl across every subdir of cwd
  tsl <n> <cmd>              Swarm layout: N tiled panes running <cmd>

CONFIG FILES
  ~/.tmux.conf
  ~/dotfiles/zsh/zshrc.d/70-tmux.zsh
  ~/.config/starship.toml
HELP
    return 0
  fi
  local name="${1:-$(basename "$PWD")}"
  name="${name//./_}"

  local cmd=""
  case "$name" in
    mm)    cmd="ssh milcmini-remote" ;;
    ts)    cmd="ssh testserver-remote" ;;
    ip)    cmd="ssh ideapad-remote" ;;
    ox)    cmd="ssh optiplex-xe2-local" ;;
    cm)    cmd="ssh creamery_mini" ;;
    mira)  cmd="ssh mira_main" ;;
    *)
      if [ -f ~/.ssh/config ] && grep -qiE "^Host .*\b${name}\b" ~/.ssh/config; then
        cmd="ssh $name"
      fi
      ;;
  esac

  local attach_cmd
  if [ -n "$TMUX" ]; then
    attach_cmd="switch-client"
  else
    attach_cmd="attach"
  fi

  if tmux has-session -t="$name" 2>/dev/null; then
    tmux $attach_cmd -t "$name"
  else
    tmux new-session -d -s "$name"
    if [ -n "$cmd" ]; then
      tmux set-option -t "$name" @is_remote 1
      tmux set-option -t "$name" @remote_cmd "$cmd"
      tmux send-keys -t "$name" "$cmd" C-m
    fi
    tmux $attach_cmd -t "$name"
  fi
}
