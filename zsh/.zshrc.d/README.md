# .zshrc.d — modular interactive zsh config

Sourced in lexical order from `~/.zshrc` (stowed from `dotfiles/zsh/`).

| File | Purpose |
|------|---------|
| `00-path.zsh` | Single PATH builder |
| `10-env.zsh` | mise activate, secrets |
| `15-history.zsh` | large shared history |
| `20-aliases.zsh` | Short aliases |
| `40-widgets.zsh` | ZLE widgets (esc-esc sudo) |
| `50-completions.zsh` | compinit + tool completions |
| `60-prompt.zsh` | starship + zoxide (guarded) |
| `70-tmux.zsh` | `t` / `tdl` / swarm helpers |
| `80-plugins.zsh` | fzf, autosuggestions, atuin, syntax-highlighting |

Local overrides: `~/.zshrc.local` (not in git).

## Package / version managers

- **Homebrew** — system CLIs (`starship`, `rg`, `fzf`, `bat`, `zoxide`, plugins)
- **mise** — runtimes only; config at `~/.config/mise/config.toml` (no `.tool-versions`)
- **Removed**: asdf, nvm, pyenv, rvm, conda, nanobrew, Appium shell helpers

## Secrets

- `CASEIN_API_TOKEN`: Keychain `casein-api-token`
- GitHub: `gh auth git-credential`
- SSH: default `~/.ssh/id_ed25519`; EC2 PEM at `~/.ssh/keys/`

## Stow layout

| Package | Home targets |
|---------|----------------|
| `zsh` | `~/.zshrc`, `~/.zshenv`, `~/.zprofile`, `~/.zlogin`, `~/.zshrc.d/` |
| `bash` | `~/.bashrc`, `~/.bash_profile`, `~/.profile`, `~/.bash_logout` |
| `git` | `~/.config/git/{config,ignore,allowed_signers}` |
| `mise` | `~/.config/mise/config.toml` |
| `ssh` | `~/.ssh/config` |
