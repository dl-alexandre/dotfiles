# Single PATH builder. Highest priority first in each list.
# Package manager: Homebrew (system CLIs, services, casks).
# Language runtimes: mise (activated in 10-env.zsh) prepends its own paths.
# See .zshrc.d/README.md.

_path_prepend() {
  # First argument ends up front (highest priority).
  local -a dirs=("$@")
  local i dir
  for (( i = ${#dirs[@]}; i > 0; i-- )); do
    dir="${dirs[i]}"
    [ -d "$dir" ] || continue
    case ":$PATH:" in
      *":$dir:"*) ;;
      *) PATH="$dir${PATH:+:$PATH}" ;;
    esac
  done
}

# Reset to a clean base (avoid inheriting duplicate junk from parent/launchd).
PATH="/usr/bin:/bin:/usr/sbin:/sbin"

# Lowest package-manager tier first, then higher tiers prepend above it.
_path_prepend /usr/local/bin
_path_prepend "$HOME/.cargo/bin"
_path_prepend /opt/homebrew/sbin /opt/homebrew/bin

# Toolchain homes (non-mise)
export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export M2_HOME="${M2_HOME:-/usr/local/apache-maven/apache-maven-3.9.9}"
export ANT_HOME="${ANT_HOME:-/usr/local/apache-ant/apache-ant-1.10.15}"
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"

# Personal / app CLIs above brew (no clash with brew formula names we care about).
_path_prepend \
  ${ANDROID_HOME:+$ANDROID_HOME/cmdline-tools/latest/bin} \
  ${ANDROID_HOME:+$ANDROID_HOME/emulator} \
  ${ANDROID_HOME:+$ANDROID_HOME/platform-tools} \
  ${ANDROID_HOME:+$ANDROID_HOME/tools} \
  ${M2_HOME:+$M2_HOME/bin} \
  ${ANT_HOME:+$ANT_HOME/bin} \
  "$HOME/.local/share/npm-global/bin" \
  "$BUN_INSTALL/bin" \
  "$HOME/.pixi/bin" \
  "$HOME/.opencode/bin" \
  "$HOME/.grok/bin" \
  "$HOME/.antigravity/antigravity/bin" \
  "$HOME/.antigravity-ide/antigravity-ide/bin" \
  "$HOME/bin" \
  "$HOME/.local/bin"

export PATH
unset -f _path_prepend
