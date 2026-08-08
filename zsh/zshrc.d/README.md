# zshrc.d — modular interactive zsh config

Sourced in lexical order from `~/.zshrc` (stowed from this directory).

| File | Purpose |
|------|---------|
| `00-path.zsh` | Single PATH builder |
| `10-env.zsh` | mise activate, secrets |
| `20-aliases.zsh` | Short aliases |
| `30-appium.zsh` | Appium / emulator helpers |
| `40-widgets.zsh` | ZLE widgets (esc-esc sudo) |
| `50-completions.zsh` | compinit + tool completions |
| `60-prompt.zsh` | starship + zoxide |
| `70-tmux.zsh` | `t` / `tdl` / swarm helpers |

Local overrides: `~/.zshrc.local` (not in git).

## Package managers: Homebrew vs nanobrew

Both stay installed. PATH order is intentional:

1. **Homebrew** (`/opt/homebrew`) — system formulas, services (postgres, openjdk deps), casks.
2. **nanobrew** (`/opt/nanobrew/prefix`) — fast CLI userland (`rg`, `fzf`, `starship`, `bat`, `aws`, …).

If the same binary exists in both, **Homebrew wins** until mise prepends. Prefer shared libs/services via brew; everyday CLIs via nanobrew when you want its build. Do not prepend nanobrew above Homebrew without updating `00-path.zsh`.

## Version manager: mise only

- **mise** (Homebrew) — node, python, java, elixir, erlang, neovim, …
- Config: `~/.config/mise/config.toml` + `~/.tool-versions` (stowed from `dotfiles/mise/`)
- npm globals: `~/.local/share/npm-global` (`prefix=` in `~/.npmrc`) — version-independent
- **Removed**: asdf, nvm, pyenv, rvm, conda/miniconda
- **Do not** `brew install` node / elixir / erlang / python@… — mise owns those runtimes

Globals (see config): node 22, python 3.13, java temurin-21, elixir 1.20.3-otp-29, erlang 29.0.5, neovim stable.

## Secrets

- `CASEIN_API_TOKEN`: Keychain item `casein-api-token` (account = `$USER`). File `~/.casein-api-token` is fallback only.
- GitHub: `gh auth git-credential` only — no `~/.git-credentials` store.
