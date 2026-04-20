#!/bin/bash
set -e

if ! command -v docker &> /dev/null; then
    echo "Install Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh

    # Add user to docker group
    sudo usermod -aG docker $USER

    rm get-docker.sh
    echo "Docker successfully installed."
else
    echo "Docker is already installed."
fi
