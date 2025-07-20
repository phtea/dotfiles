#!/usr/bin/env bash
set -e

echo "=== Syncing and updating system ==="
sudo pacman -Syu --needed

echo "=== Installing core packages ==="
sudo pacman -S --needed \
  base-devel git \
  gvim neovim ripgrep fd \
  stow fzf entr tmux ghostty polybar pamixer acpi picom rofi \
  ttf-font-awesome ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common noto-fonts-emoji \
  pipewire pipewire-pulse wireplumber networkmanager bluez blueman \
  xorg-server xorg-xinit xterm xorg-xrandr xorg-xset xorg-xprop xorg-xinput xorg-xkbcomp xorg-xauth xorg-xmodmap xorg-xrdb \
  i3-wm i3lock xss-lock dunst dex feh scrot xclip brightnessctl \
  libnotify thunar less fastfetch \

echo "=== Enabling necessary services ==="
sudo systemctl enable --now NetworkManager bluetooth

echo "=== Enabling user-level services ==="

sudo loginctl enable-linger "$USER"

systemctl --user enable --now pipewire.socket pipewire-pulse.socket

echo "=== Stowing dotfiles ==="
cd ~/dotfiles
stow bash ghostty git i3 nvim picom polybar rofi scripts tmux vim
# stow helix

echo "=== Installation complete! ==="
echo "Make sure your ~/.xinitrc runs i3 (exec i3)"
echo "Reboot or relogin to start your environment."
