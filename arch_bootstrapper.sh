#!/usr/bin/env bash
set -e

echo "=== Syncing and updating system ==="
sudo pacman -Syu --needed

echo "=== Calling package installation script ==="
bash arch_sync_packages.sh

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
