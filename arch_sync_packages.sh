#!/usr/bin/env bash
set -e

echo "=== Installing core packages ==="
sudo pacman -S --needed \
  base-devel git \
  gvim neovim ripgrep fd \
  stow fzf entr tmux ghostty polybar pamixer acpi picom rofi rofi-emoji \
  ttf-font-awesome ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common noto-fonts-emoji ttf-fira-code \
  pipewire pipewire-pulse wireplumber networkmanager bluez blueman \
  xorg-server xorg-xinit xterm xorg-xrandr xorg-xset xorg-xprop xorg-xinput xorg-xkbcomp xorg-xauth xorg-xmodmap xorg-xrdb \
  i3-wm i3lock xss-lock dunst dex feh scrot xclip brightnessctl \
  libnotify thunar less fastfetch mpv yt-dlp

echo "=== Installation complete! ==="
