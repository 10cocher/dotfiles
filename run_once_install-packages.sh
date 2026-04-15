#!/bin/bash

sudo apt update
sudo apt install -y build-essential wget unzip ripgrep fd-find

echo "Installing graphical dependencies for Alacritty"
sudo apt install -y cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

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

# ==========================================
# Compiling from Source: Alacritty
# ==========================================
if ! command -v alacritty &> /dev/null; then
    echo "Compiling Alacritty from source. This will put your CPU to work..."

    # Clone into a hidden source directory
    git clone https://github.com/alacritty/alacritty.git ~/.alacritty-source
    cd ~/.alacritty-source

    # Check the latest stable release tag (e.g. v0.17.0)
    LATEST_TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
    echo "Checking out stable release: $LATEST_TAG"
    git checkout $LATEST_TAG

    # Compile the highly-optimized release build
    cargo build --release

    # Distribute the compiled binary to the system
    sudo cp target/release/alacritty /usr/local/bin/

    # Set up the desktop icon so it appears in your GNOME launcher
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database

    echo "Alacritty compilation complete!"
else
    echo "Alacritty is already installed."
fi


# ==========================================
# Typography (Nerd Fonts)
# ==========================================
if [ ! -d "$HOME/.local/share/fonts/JetBrainsMono" ]; then
    echo "Downloading JetBrains Mono Nerd Font..."
    mkdir -p "$HOME/.local/share/fonts/JetBrainsMono"

    # Download the latest release directly from the source
    wget -qO /tmp/JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

    # Unpack it into the local fonts directory
    unzip -q /tmp/JetBrainsMono.zip -d "$HOME/.local/share/fonts/JetBrainsMono"
    rm /tmp/JetBrainsMono.zip

    # Force the system to recognize the new fonts immediately
    fc-cache -fv

    echo "JetBrains Mono installed successfully!"
else
    echo "JetBrains Mono Nerd Font is already installed."
fi


# ==========================================
# System Shell Configuration
# ==========================================
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Change shell configuration to use Zsh"
    sudo chsh -s $(which zsh) $(whoami)
    echo "Default shell changed to Zsh! (Requires a logout/login to take full effect)"
else
    echo "Zsh is already the default shell."
fi
