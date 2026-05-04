#!/bin/bash
set -e

sudo add-apt-repository -y ppa:libreoffice/ppa
sudo apt update
sudo apt install -y build-essential cmake libtool-bin wget unzip ripgrep fd-find zsh wl-clipboard libreoffice libreoffice-gnome


# ==========================================
# Toolchains (Rust & Mise)
# ==========================================

# Install Rust (Idempotent)
if ! command -v cargo &> /dev/null; then
    echo "Installing the Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # We must source the environment right now so the rest of the script can use 'cargo'
    . "$HOME/.cargo/env"
else
    echo "Rust is already installed."
fi

# Install Mise
if ! command -v mise &> /dev/null; then
    echo "Installing Mise toolchain manager..."
    curl https://mise.run | sh
fi

# Install Starship
if ! command -v starship &> /dev/null; then
    echo "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Install Atuin
if ! command -v atuin &> /dev/null; then
    echo "Installing Atuin history database..."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
else
    echo "Atuin is already installed."
fi
