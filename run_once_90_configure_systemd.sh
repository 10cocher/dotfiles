#!/bin/bash
set -e

if command -v emacs &> /dev/null; then
    echo "Handling Emacs over to the systemd engine..."
    systemctl --user enable --now emacs
    echo "Emacs background daemin is permanently online."
fi
