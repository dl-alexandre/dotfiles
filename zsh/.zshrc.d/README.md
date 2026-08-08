# .zshrc.d — modular interactive zsh config

Sourced in lexical order from `~/.zshrc` (stowed from `dotfiles/zsh/`).

| File | Purpose |
|------|---------|
| `00-path.zsh` | Single PATH builder |
| `10-env.zsh` | mise activate, secrets |
| `20-aliases.zsh` | Short aliases |
| `30-appium.zsh` | Appium / emulator helpers (`apm`, `apm_ext`, `kl`) |
| `40-widgets.zsh` | ZLE widgets (esc-esc sudo) |
| `50-completions.zsh` | compinit + tool completions |
| `60-prompt.zsh` | starship + zoxide (guarded) |
| `70-tmux.zsh` | `t` / `tdl` / swarm helpers |

Local overrides: `~/.zshrc.local` (not in git).

## Package manager

**Homebrew** (`/opt/homebrew`) owns system CLIs and services. Everyday tools (`starship`, `rg`, `fzf`, `bat`, `zoxide`) are brew formulas.

## Version manager: mise only

- **mise** (Homebrew) — node, python, java, elixir, erlang, neovim, …
- Config: `~/.config/mise/config.toml` + `~/.tool-versions` (stowed from `dotfiles/mise/`)
- npm globals: `~/.local/share/npm-global` (`prefix=` in `~/.npmrc`)
- **Removed**: asdf, nvm, pyenv, rvm, conda/miniconda, nanobrew, Appium shell helpers
- **Updates**: `brew upgrade mise` / daily brew autoupdate

## Secrets

- `CASEIN_API_TOKEN`: Keychain item `casein-api-token` (account = `$USER`)
- GitHub: `gh auth git-credential` only

## Stow layout

| Package | Home targets |
|---------|----------------|
| `zsh` | `~/.zshrc`, `~/.zshenv`, `~/.zprofile`, `~/.zlogin`, `~/.zshrc.d/` |
| `bash` | `~/.bashrc`, `~/.bash_profile`, `~/.profile`, `~/.bash_logout` |
| `git` | `~/.config/git/{config,ignore}` (no `~/.gitconfig`) |
| `mise` | `~/.tool-versions`, `~/.config/mise/config.toml` |
