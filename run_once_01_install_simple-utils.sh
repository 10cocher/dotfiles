#!/bin/bash
set -e

# ==========================================
# uv
# ==========================================

if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv is already installed."
fi

# ==========================================
# D2 architecture diagrams
# ==========================================

if ! command -v d2 &> /dev/null; then
    echo "Installing d2..."
    curl -fsSL https://d2lang.com/install.sh | sh -s --
else
    echo "D2 is already installed."
fi
