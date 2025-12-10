# Dotfiles

Personal dotfiles managed with GNU Stow.

## Setup

1. Copy `.env.local.example` to `.env.local` and customize machine-specific variables.
2. Run `./install.sh` to install all dotfiles.
3. Run `./install.sh uninstall` to remove them.

## Requirements

- GNU Stow
- Bash

## Additional Packages

After installation, consider installing:

- `yay -S losslesscut-bin` - Video editing tool
- `yay -S omarchy` - Theme manager (see [omarchy.com](https://omarchy.com))

## Sudoers Configuration

Configure sudoers for auto-power.sh:

```bash
sudo visudo -f /etc/sudoers.d/cpu-thermal
```

Add these lines:

```
%wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/devices/system/cpu/*/cpufreq/scaling_governor
%wheel ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/thermal/thermal_zone2/policy
```

## Notes

- Helium browser data is included; review for sensitive information before committing.
- Scripts are in `.local/bin/` for easy access.