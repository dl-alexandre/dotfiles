# Agent Instructions & Learned Experiences

## Dotfiles & Configuration Management

### Don't Duplicate Omarchy Defaults in Dotfiles
When investigating features that are part of the base omarchy distribution, verify if they're already included as defaults before adding to dotfiles. Omarchy v3.1.0+ includes universal copy/paste (Super+C/V) via Hyprland's `sendshortcut` dispatcher in `~/.local/share/omarchy/default/hypr/bindings/clipboard.conf`. Don't duplicate these in personal dotfiles unless customizing.

**Reference:** Omarchy implements this through:
```conf
bindd = SUPER, C, Universal copy, sendshortcut, CTRL, Insert,
bindd = SUPER, V, Universal paste, sendshortcut, SHIFT, Insert,
bindd = SUPER, X, Universal cut, sendshortcut, CTRL, X,
```

This uses Hyprland's `sendshortcut` dispatcher instead of keyd or other workarounds.
