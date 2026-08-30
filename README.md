# Dotfiles

Personal configuration files, managed with GNU Stow. Split into modules to switch between X11 and Wayland while keeping common configs separate.

## Prerequisites

```bash
sudo pacman -S git stow
```

## Installation

```bash
git clone https://github.com/repen7ant/dotfiles ~/dotfiles
cd ~/dotfiles
```

## Applying Configurations

### Common (Bash, Neovim, Kitty, Starship, Yazi, etc.)

```bash
cd ~/dotfiles/common
stow -t ~ *
```

### Graphical Environment

**Wayland (Niri, Quickshell, Fuzzel):**

`wayland` is a single stow package, so it is applied from the repo root:

```bash
cd ~/dotfiles
stow -t ~ wayland
```

**X11 (i3, Polybar, Rofi, Picom, etc.):**

```bash
cd ~/dotfiles/xorg
stow -t ~ *
```

## Troubleshooting

**Conflict error** — target already exists:

```bash
rm -rf ~/.config/nvim
cd ~/dotfiles/common
stow -t ~ nvim
```

**Remove symlinks:**

```bash
cd ~/dotfiles/common   # or xorg
stow -t ~ -D *

cd ~/dotfiles
stow -t ~ -D wayland
```

## Packages

```bash
yay -S --needed discord dbeaver gimp github-desktop-bin helium-browser-bin libreoffice-still moonlight-qt qbittorrent telegram-desktop torbrowser-launcher virt-manager v2raya waypaper picard gpu-screen-recorder-ui fuzzel 7zip btop cmatrix cuetools fastfetch fd fzf less mpv neovim nmap ripgrep rsync shntool speedtest-cli tree unzip wget wl-clipboard yazi zip zoxide tailscale gpu-screen-recorder stow starship cmake composer docker docker-buildx docker-compose go jdk17-openjdk jdk21-openjdk kitty npm python-uv ruff git tree-sitter-cli niri swaybg wlsunset quickshell upower power-profiles-daemon mpd libvirt qemu-full ly
```
