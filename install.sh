#!/bin/bash
# Install dotfiles using stow

set -e
shopt -s nullglob  # Prevent globbing errors if no matches

# Check if stow is installed
if ! command -v stow &> /dev/null; then
  echo "Error: stow is not installed. Please install it first."
  exit 1
fi

# Function to show usage
usage() {
  echo "Usage: $0 [install|uninstall]"
  echo "  install  - Stow dotfiles (default)"
  echo "  uninstall - Unstow dotfiles"
  exit 1
}

ACTION="install"
if [[ $# -gt 0 ]]; then
  case $1 in
    install) ACTION="install" ;;
    uninstall) ACTION="uninstall" ;;
    *) usage ;;
  esac
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Dynamically get packages from directories (excluding hidden and non-dotfile dirs)
PACKAGES=()
for dir in */; do
  dir=${dir%/}
  if [[ -d "$dir" && ! "$dir" =~ ^\. && "$dir" != "scripts" ]]; then
    PACKAGES+=("$dir")
  fi
done
# Add scripts separately as it's nested
PACKAGES+=("scripts")

if [[ "$ACTION" == "install" ]]; then
  echo "Installing dotfiles from $DOTFILES_DIR..."
  echo "Packages to install: ${PACKAGES[*]}"
  STOW_CMD="stow --restow"
else
  echo "Uninstalling dotfiles from $DOTFILES_DIR..."
  echo "Packages to uninstall: ${PACKAGES[*]}"
  STOW_CMD="stow --delete"
fi

cd "$DOTFILES_DIR"

for package in "${PACKAGES[@]}"; do
  if [[ -d "$package" ]]; then
    echo "Processing $package..."
    $STOW_CMD "$package"
  else
    echo "Warning: Directory $package not found, skipping."
  fi
done

echo "Operation completed successfully!"

echo "Dotfiles installed successfully!"
echo ""

echo ""
echo "Additional packages to install:"
echo "  yay -S losslesscut-bin  # Video editing tool"
echo "  yay -S omarchy          # Theme manager (see omarchy.com)"
echo ""
echo "Remember to configure sudoers for auto-power.sh:"
echo "  sudo visudo -f /etc/sudoers.d/cpu-thermal"
echo ""
echo "Add these lines:"
echo "  %wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/devices/system/cpu/*/cpufreq/scaling_governor"
echo "  %wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/thermal/thermal_zone*/policy"
