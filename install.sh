#!/bin/bash
# Install dotfiles using stow

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Common packages for all OS
PACKAGES_COMMON=(
  "bash"
  "git"
  "gnupg"
  "scripts"
  "ssh"
  "starship"
)

# Linux-specific packages
PACKAGES_LINUX=(
  "btop"
  "fonts"
  "environment.d"
  "fastfetch"
  "fcitx5"
  "ghostty"
  "hypr"
  "kitty"
  "swayosd"
  "systemd"
  "uwsm"
  "walker"
  "waybar"
  "xournalpp"
)

# macOS-specific packages (add your macOS configs here)
PACKAGES_MACOS=(
  "zsh"
  "asdf"
  "clang"
  "aerospace"
  "tmux"
  "fish"
)

# Detect OS and set packages
if [[ "$OSTYPE" == "darwin"* ]]; then
  PACKAGES=("${PACKAGES_COMMON[@]}" "${PACKAGES_MACOS[@]}")
else
  PACKAGES=("${PACKAGES_COMMON[@]}" "${PACKAGES_LINUX[@]}")
fi

echo "Installing dotfiles from $DOTFILES_DIR..."

cd "$DOTFILES_DIR"

for package in "${PACKAGES[@]}"; do
  echo "Stowing $package..."
  stow --adopt "$package"
done

echo "Dotfiles installed successfully!"
echo ""

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo ""
  echo "Remember to configure sudoers for auto-power.sh:"
  echo "  sudo visudo -f /etc/sudoers.d/cpu-thermal"
  echo ""
  echo "Add these lines:"
  echo "  %wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/devices/system/cpu/*/cpufreq/scaling_governor"
  echo "  %wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/thermal/thermal_zone*/policy"
fi
