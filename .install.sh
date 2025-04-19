#!/bin/bash

# install.sh
# This script is executed by VS Code Dev Containers after cloning the dotfiles repository.
# It uses GNU Stow to create symlinks in the home directory.

echo "Running dotfiles install.sh..."

# Ensure stow is available
# In a DevContainer, this might already be installed or part of a setup script,
# but it's good practice to include an installation step if it might not be present.
# This example uses apt-get, commonly found in Debian/Ubuntu based containers.
# Adjust the package manager as needed for your base image if not Debian/Ubuntu.
if ! command -v stow &> /dev/null
then
    echo "Stow not found, attempting to install..."
    # Update package list in case it's stale
    sudo apt-get update -y
    sudo apt-get install -y stow
    if ! command -v stow &> /dev/null
    then
        echo "Error: Failed to install stow. Please install it manually."
        exit 1
    fi
fi

# Navigate to the dotfiles directory (where this script is located)
# This step might be redundant based on DevContainer behavior, but adds robustness.
DOTFILES_DIR="$HOME/dotfiles" # Or use PWD if you're certain of execution location
if [ -d "$DOTFILES_DIR" ]; then
    cd "$DOTFILES_DIR"
else
    echo "Error: Dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

# Run stow to create symlinks for all packages
echo "Running stow to create symlinks..."
stow *

# Check if stow command was successful (optional)
if [ $? -eq 0 ]; then
    echo "Stow successfully executed."
else
    echo "Stow encountered errors. Check output above."
    # Depending on how strict you want, you might exit here
    # exit 1
fi

echo "Dotfiles installation script finished."

exit 0 # Indicate success
