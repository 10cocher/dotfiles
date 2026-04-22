#!/bin/bash
set -e

# ==========================================
# D2 architecture diagrams
# ==========================================

if ! command -v d2 &> /dev/null; then
    echo "Installing d2..."
    curl -fsSL https://d2lang.com/install.sh | sh -s --
else
    echo "D2 is already installed."
fi
