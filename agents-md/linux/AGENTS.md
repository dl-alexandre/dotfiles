# AGENTS.md

This file documents the system configuration for alexandre's Omarchy Linux environment. It is read by AI coding agents to understand the setup and avoid breaking changes when making modifications.

## Overview

This system runs **Omarchy Linux**, Basecamp's opinionated Arch Linux distribution built on **Hyprland**. The configuration follows Omarchy's layered architecture where user overrides live in `~/.config/` and never modify system defaults in `~/.local/share/omarchy/`.

All dotfiles are managed with **GNU Stow** from `~/dotfiles/`. The installation script uses `stow --restow --adopt` to create symlinks and handle conflicts.

## Architecture

### Omarchy's Layered Configuration System

Omarchy uses a three-layer configuration system with clear precedence:

1. **System Defaults** (`~/.local/share/omarchy/default/`) - Managed by omarchy-update, DO NOT EDIT
2. **Theme Overrides** (`~/.config/omarchy/current/theme/`) - Changed via `omarchy-theme-set`
3. **User Overrides** (`~/.config/`) - Your personal customizations, takes highest precedence

Later sources override earlier ones. User settings always win.

### Dotfiles Management

- **Tool**: GNU Stow
- **Location**: `~/dotfiles/`
- **Structure**: Each application has its own directory with the expected config path inside
- **Installation**: `./install.sh` (uses `stow --restow --adopt`)
- **Uninstallation**: `./install.sh uninstall` (uses `stow --delete`)

Example structure:
```
~/dotfiles/
├── hypr/.config/hypr/looknfeel.conf → ~/.config/hypr/looknfeel.conf
├── nvim/.config/nvim/init.lua → ~/.config/nvim/init.lua
└── waybar/.config/waybar/config.jsonc → ~/.config/waybar/config.jsonc
```

## Key Directories

| Directory | Purpose |
|-----------|---------|
| `~/.config/hypr/` | Hyprland compositor configuration |
| `~/.config/waybar/` | Status bar configuration |
| `~/.config/walker/` | Application launcher configuration |
| `~/.config/ghostty/` | Ghostty terminal emulator |
| `~/.config/kitty/` | Kitty terminal emulator |
| `~/.config/nvim/` | Neovim with LazyVim |
| `~/.config/starship/` | Starship prompt |
| `~/.local/bin/` | User scripts and utilities |
| `~/dotfiles/` | Version-controlled configuration |
| `~/.local/share/omarchy/default/` | System defaults (read-only) |

## Core Configuration Files

### Hyprland (Compositor)

| File | Purpose |
|------|---------|
| `hypr/hyprland.conf` | Main orchestrator, sources all other configs |
| `hypr/bindings.conf` | Custom keybindings (applications, window management) |
| `hypr/looknfeel.conf` | Visual settings (borders, gaps, blur - currently uses defaults) |
| `hypr/monitors.conf` | Display configuration |
| `hypr/input.conf` | Keyboard and touchpad settings |
| `hypr/autostart.conf` | Startup applications |
| `hypr/envs.conf` | Environment variables |
| `hypr/hypridle.conf` | Idle management |
| `hypr/hyprsunset.conf` | Blue light filter |
| `hypr/hyprlock.conf` | Screen lock |

### Waybar (Status Bar)

| File | Purpose |
|------|---------|
| `waybar/config.jsonc` | Module layout and behavior |
| `waybar/style.css` | Styling (imports theme variables) |

### Other Applications

| File | Purpose |
|------|---------|
| `walker/config.toml` | Application launcher configuration |
| `ghostty/config` | Ghostty terminal settings |
| `kitty/kitty.conf` | Kitty terminal settings |
| `nvim/lazyvim.json` | LazyVim configuration |
| `starship/starship.toml` | Starship prompt configuration |
| `tmux/tmux.conf` | Tmux configuration |
| `git/config` | Git configuration |
| `gh/config.yml` | GitHub CLI configuration |
| `zsh/.zshrc` | Zsh shell configuration |
| `bash/.bashrc` | Bash shell configuration |
| `btop/btop.conf` | System monitor configuration |
| `fastfetch/config.jsonc` | System info display |
| `fcitx5/conf/xcb.conf` | Input method configuration |
| `swayosd/config.toml` | On-screen display |

## Preferences and Customizations

### Visual Settings

The system uses Omarchy's default look and feel settings. User overrides in `looknfeel.conf` are currently commented out, meaning defaults apply for:
- Window gaps
- Border sizes
- Corner rounding
- Animations

### Monitor Configuration

Two displays are configured:
- **HDMI-A-1**: 1920x1080 at position 0x0 (external monitor)
- **eDP-1**: 1440x900 at position 240x1080 (internal laptop display)

Scale is set to 1x (`GDK_SCALE=1`).

### Input Settings

- **Keyboard**: US layout with compose:caps for special characters
- **Repeat rate**: 40 repeats per second, 600ms delay
- **Numlock**: On by default
- **Touchpad**: Natural scroll disabled, scroll factor 0.4, two-finger right-click disabled

Window rules apply custom scroll factors for terminals:
- Alacritty/kitty: scroll_touchpad = 1.5
- Ghostty: scroll_touchpad = 0.2

### Keybindings

Keybindings follow this format: `bindd = MODIFIERS, KEY, Description, dispatcher, arguments`

**Modifier abbreviations:**
- `SUPER` = Windows/Command key
- `SHIFT`, `CTRL`, `ALT` = Standard modifiers
- `SUPER_L SUPER_R` = Both super keys

**Essential bindings:**
- `SUPER + RETURN` - Terminal (opens in current directory)
- `SUPER + SHIFT + RETURN` - Terminal with OpenCode
- `SUPER + SHIFT + F` - File manager
- `SUPER + SHIFT + B` - Browser
- `SUPER + SHIFT + N` - Editor
- `SUPER + SHIFT + S` - Activity monitor (btop)
- `SUPER + SHIFT + D` - Docker (lazydocker)
- `SUPER + SHIFT + O` - Obsidian
- `SUPER + SHIFT + ALT + C` - Cursor editor
- `SUPER + SPACE` - Launch Walker (app launcher)
- `SUPER + ALT + SPACE` - Omarchy menu (from defaults)
- `SUPER + R` - Restart Hyprland

**Universal copy/paste** is sourced from Omarchy defaults (`~/.local/share/omarchy/default/hypr/bindings/clipboard.conf`) using Hyprland's `sendshortcut` dispatcher.

### Development Environment

- **Node.js**: Managed via nvm, current version v23.10.0
- **Python**: Managed via pyenv, system Python 3.13
- **Java**: Java 21 (via /usr/libexec/java_home)
- **Android SDK**: Located at ~/Library/Android/sdk (macOS compatibility)
- **Maven**: /usr/local/apache-maven/apache-maven-3.9.9
- **Ant**: /usr/local/apache-ant/apache-ant-1.10.15
- **Bun**: ~/.bun
- **Zoxide**: For smarter cd
- **asdf**: Version manager for multiple runtimes

### Terminal Applications

- **Terminal**: Ghostty (primary), Kitty (secondary)
- **Shell**: Zsh with vi mode (`bindkey -v`)
- **Prompt**: Starship
- **Editor**: Neovim with LazyVim, includes neo-tree plugin
- ** multiplexer**: Tmux
- **CLI tools**: fastfetch, btop, fzf

### Version Control

- **Git**: Configured with user settings
- **GitHub CLI**: Configured with HTTPS protocol, alias `co` for `pr checkout`
- **SSH**: Keys managed in `~/.ssh/` (not in dotfiles for security)

### System Monitoring

- **btop**: Activity monitor configured, accessible via `SUPER + SHIFT + S`
- **Temperature**: Waybar module shows CPU temperature, thermal zone 0
- **Battery**: Waybar module shows capacity with icons, auto-power script on click
- **Network**: Waybar module shows WiFi signal with bandwidth tooltips

## Common Operations

### Applying Configuration Changes

| Component | Command |
|-----------|---------|
| Hyprland | `omarchy-refresh-hyprland` or `hyprctl reload` |
| Waybar | `omarchy-refresh-waybar` or restart waybar |
| Window manager | `SUPER + ALT + R` (restart Hyprland) |

### Managing Dotfiles

```bash
# Install or update symlinks
cd ~/dotfiles && ./install.sh

# Remove symlinks
cd ~/dotfiles && ./install.sh uninstall

# Stow a new package manually
cd ~/dotfiles && stow --restow package-name
```

### Theme Management

```bash
# List available themes
omarchy-theme-list

# Switch theme
omarchy-theme-set theme-name
```

### Common Maintenance Tasks

**Add a new keybinding:**
Edit `~/dotfiles/hypr/.config/hypr/bindings.conf` following the format:
`bindd = SUPER, KEY, Description, exec, command`

**Add a window rule:**
Add to `~/dotfiles/hypr/.config/hypr/hyprland.conf`:
`windowrule = RULE, PATTERN`

**Change monitor configuration:**
Edit `~/dotfiles/hypr/.config/hypr/monitors.conf`:
`monitor = PORT, RESOLUTION, POSITION, SCALE`

**Add a new dotfiles package:**
1. Create directory structure in `~/dotfiles/`
2. Run `./install.sh` to symlink

## Troubleshooting Guide

### Hyprland Issues

**Black screen or compositor crash:**
- Press `SUPER + ESC` to attempt recovery
- Check logs: `journalctl -u Hyprland`
- Try `hyprctl reload` or `SUPER + ALT + R`

**Keybindings not working:**
- Verify file is sourced in `hyprland.conf`
- Check for syntax errors in config
- Run `hyprctl bindv` to list active bindings

**Window not tiling:**
- Check `windowrule` matches correctly
- Use `hyprctl windows` to see window properties

### Waybar Issues

**Modules not updating:**
- Check Waybar is running: `pkill waybar && waybar &`
- Verify JSONC syntax (trailing commas are errors)
- Check Waybar logs: `journalctl -t waybar`

**Custom scripts not working:**
- Ensure scripts are executable: `chmod +x ~/.local/bin/script.sh`
- Check script has correct shebang

### Display Issues

**Monitor not detected:**
- Run `hyprctl monitors` to see detected displays
- Verify cables and drivers
- Check `monitors.conf` syntax

**Wrong resolution:**
- Remove `monitors.conf` to reset to defaults
- Configure via `hyprland.conf` or arandr

### Dotfiles Issues

**Symlink conflicts:**
- Use `stow --restow --adopt` to resolve
- Manually remove conflicting files first

**Stow not creating links:**
- Check directory structure matches home layout
- Verify no trailing slashes in stow target

## Critical Rules for AI Agents

### Do

- Read existing configurations before making changes
- Follow the layered config system (user overrides in ~/.config/)
- Check Omarchy defaults first before adding to dotfiles
- Use the same formatting and conventions as existing files
- Test changes before marking complete
- Check `journalctl` for errors when things break

### Don't

- DO NOT edit files in `~/.local/share/omarchy/default/` (changes lost on update)
- DO NOT duplicate Omarchy defaults in personal dotfiles unless customizing
- DO NOT hardcode theme names in configs (use symlinks)
- DO NOT forget trailing commas in JSON/JSONC configs
- DO NOT assume macOS paths work on Linux (note Android SDK path in zshrc is macOS-specific)
- DO NOT modify system files that are managed by omarchy-update
- DO NOT break the layered override system

### Important Notes

- Universal copy/paste is handled by Omarchy defaults via `sendshortcut` dispatcher - don't duplicate
- Some zshrc paths are macOS-specific (Android SDK, conda, Docker Desktop, LM Studio, Antigravity, Pixi, bun)
- The keyboard layout switching binding for Apple keyboard is disabled but documented
- Sudoers configuration is required for auto-power.sh to work
- Some bindings are commented out or disabled - check before enabling

## Environment Variables

Key environment variables set in various configs:

| Variable | Value | Location |
|----------|-------|----------|
| `PATH` | Extended with nvm, Java, Android SDK, Maven, Ant, pyenv, bun, zoxide, local bin | zshrc |
| `NVM_DIR` | ~/.nvm | zshrc |
| `NODE_HOME` | nvm versions path | zshrc |
| `JAVA_HOME` | /usr/libexec/java_home -v 21 | zshrc |
| `ANDROID_HOME` | ~/Library/Android/sdk | zshrc (macOS) |
| `M2_HOME` | /usr/local/apache-maven/apache-maven-3.9.9 | zshrc |
| `PYENV_ROOT` | ~/.pyenv | zshrc |
| `BUN_INSTALL` | ~/.bun | zshrc |
| `GDK_SCALE` | 1 | monitors.conf |
| `EDITOR` | Set by system defaults | various |

## Quick Reference

### Essential Commands

| Task | Command |
|------|---------|
| Refresh Hyprland | `omarchy-refresh-hyprland` or `hyprctl reload` |
| Refresh Waybar | `omarchy-refresh-waybar` |
| Restart Hyprland | `SUPER + ALT + R` |
| List windows | `hyprctl windows` |
| List monitors | `hyprctl monitors` |
| Check Waybar logs | `journalctl -t waybar` |
| Check Hyprland logs | `journalctl -u Hyprland` |
| Install dotfiles | `cd ~/dotfiles && ./install.sh` |
| Uninstall dotfiles | `cd ~/dotfiles && ./install.sh uninstall` |

### Key Files Reference

| Task | File |
|------|------|
| Keybindings | `~/.config/hypr/bindings.conf` |
| Monitor setup | `~/.config/hypr/monitors.conf` |
| Input settings | `~/.config/hypr/input.conf` |
| Waybar config | `~/.config/waybar/config.jsonc` |
| Waybar style | `~/.config/waybar/style.css` |
| Walker config | `~/.config/walker/config.toml` |
| Terminal (ghostty) | `~/.config/ghostty/config` |
| Terminal (kitty) | `~/.config/kitty/kitty.conf` |
| Neovim config | `~/.config/nvim/lazyvim.json` |
| Shell (zsh) | `~/.zshrc` |
| Starship prompt | `~/.config/starship/starship.toml` |
| Git config | `~/.gitconfig` |
| GitHub CLI | `~/.config/gh/config.yml` |
| System monitor | `~/.config/btop/btop.conf` |

## References

- **Omarchy Manual**: https://learn.omacom.io/
- **Hyprland Wiki**: https://wiki.hyprland.org/
- **Waybar Wiki**: https://github.com/Alexays/Waybar/wiki/
- **GNU Stow Manual**: https://www.gnu.org/software/stow/
- **LazyVim Documentation**: https://lazyvim.org/
