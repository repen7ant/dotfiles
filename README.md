# Dotfiles

My personal configuration files, managed with GNU Stow. The repository is organized into modules to easily switch between display servers (X11 and Wayland) while keeping common application configurations separate.

## Prerequisites

Before applying the configurations, ensure you have `git` and `stow` installed on your system.

```bash
# For Arch Linux
sudo pacman -S git stow
```

## Installation

1. Clone this repository into your home directory:

```bash
git clone https://github.com/repen7ant/dotfiles ~/dotfiles
cd ~/dotfiles
```

2. Make sure you don't have existing default configuration files in your `~` or `~/.config` directories for the apps you are about to stow. If you do, `stow` will abort to prevent overwriting them.

## Applying Configurations

Use `stow` with the `-d` (directory) and `-t` (target) flags to apply the symlinks.

### 1. Common Base

Apply configurations for universal tools (Bash, Neovim, Kitty, Starship, Yazi, etc.) that do not depend on the display server:

```bash
cd common
stow -d -t ~ *
```

### 2. Graphical Environment

Choose **one** of the following depending on your current display server setup:

**For Wayland:**

```bash
cd wayland
stow -d -t ~ *
```

**For X11 (i3, Polybar, Rofi, Picom, etc.):**

```bash
cd xorg
stow -d -t ~ *
```

## Troubleshooting

### "WARNING! stowing ... would cause conflicts"

If `stow` throws this error, it means a file or directory already exists at the target location.

To fix this, remove the conflicting file or directory (make sure to back it up if it contains important data) and run the `stow` command again.

Example:

```bash
# If stow complains about ~/.config/nvim
rm -rf ~/.config/nvim
stow -d -t ~ nvim
```

### Removing Symlinks

If you need to uninstall a configuration and remove its symlinks from your home directory, use the `-D` (delete) flag:

```bash
# Example: removing Xorg configs
cd xorg
stow -d -t ~ -D *
```
