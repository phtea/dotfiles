#!/usr/bin/env bash
set -e

echo "=== Syncing and updating system ==="
sudo pacman -Syu --needed

echo "=== Calling package installation script ==="
bash arch_sync_packages.sh

echo "=== Enabling necessary services ==="
sudo systemctl enable --now NetworkManager bluetooth bluetooth.service

echo "=== Enabling user-level services ==="

sudo loginctl enable-linger "$USER"

systemctl --user enable --now pipewire.socket pipewire-pulse.socket

echo "=== Stowing dotfiles ==="
cd ~/dotfiles
rm ~/.bashrc ~/.bash_profile
stow bash ghostty git i3 nvim picom polybar rofi scripts tmux vim dunst wallpapers
sudo ln -s ~/dotfiles/custom_symlinks/99-touchpad.conf /etc/X11/xorg.conf.d/99-touchpad.conf || echo "[WARNING] Failed to create symlink for touch pad"

echo "=== Setting default background image ==="
feh --bg-scale ~/Pictures/Wallpapers/arch_linux.png

echo "=== Installation complete! ==="
echo "Make sure your ~/.xinitrc runs i3 (exec i3)"
echo "Reboot or relogin to start your environment."
