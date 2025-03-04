#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt update -y

# Install dependencies
echo "Installing dependencies for Neovim..."
sudo apt install -y fd-find ripgrep build-essential

# Verify installation
echo "Checking installed packages..."
if command -v fdfind &> /dev/null; then
    echo "✔ fd-find installed successfully."
else
    echo "❌ fd-find installation failed."
fi

if command -v rg &> /dev/null; then
    echo "✔ ripgrep installed successfully."
else
    echo "❌ ripgrep installation failed."
fi

if dpkg -l | grep -q build-essential; then
    echo "✔ build-essential installed successfully."
else
    echo "❌ build-essential installation failed."
fi

echo "✅ All dependencies installed!"
