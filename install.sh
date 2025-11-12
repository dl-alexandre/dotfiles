#!/bin/bash
# Install dotfiles using stow

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(
  "alacritty"
  "bash"
  "btop"
  "environment.d"
  "fastfetch"
  "fcitx5"
  "git"
  "gnupg"
  "hypr"
  "kitty"
  "scripts"
  "ssh"
  "starship"
  "swayosd"
  "systemd"
  "uwsm"
  "walker"
  "waybar"
  "xournalpp"
)

echo "Installing dotfiles from $DOTFILES_DIR..."

cd "$DOTFILES_DIR"

for package in "${PACKAGES[@]}"; do
  echo "Stowing $package..."
  stow "$package"
done

echo "Dotfiles installed successfully!"
echo ""

echo ""
echo "Remember to configure sudoers for auto-power.sh:"
echo "  sudo visudo -f /etc/sudoers.d/cpu-thermal"
echo ""
echo "Add these lines:"
echo "  %wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/devices/system/cpu/*/cpufreq/scaling_governor"
echo "  %wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/thermal/thermal_zone*/policy"
