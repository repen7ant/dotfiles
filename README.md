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
cd common
stow -t ~ *
```

### Graphical Environment

**Wayland:**

```bash
cd wayland
stow -t ~ *
```

**X11 (i3, Polybar, Rofi, Picom, etc.):**

```bash
cd xorg
stow -t ~ *
```

## Troubleshooting

**Conflict error** — target already exists:

```bash
rm -rf ~/.config/nvim
stow -t ~ nvim
```

**Remove symlinks:**

```bash
cd xorg
stow -t ~ -D *
```

## Packages

```bash
yay -S --needed discord dbeaver gimp github-desktop-bin helium-browser-bin libreoffice-still moonlight-qt qbittorrent telegram-desktop torbrowser-launcher virt-manager v2raya waypaper picard gpu-screen-recorder-ui fuzzel 7zip btop cmatrix cuetools fastfetch fd fzf less mpv neovim nmap ripgrep rsync shntool speedtest-cli tree unzip wget wl-clipboard yazi zip zoxide tailscale gpu-screen-recorder stow starship cmake composer docker docker-buildx docker-compose go jdk17-openjdk jdk21-openjdk kitty npm python-uv ruff git tree-sitter-cli niri swaybg wlsunset quickshell mpd libvirt qemu-full ly
```
