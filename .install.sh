#!/bin/bash

# install.sh
# This script is executed by VS Code Dev Containers after cloning the dotfiles repository.
# It uses GNU Stow to create symlinks in the home directory.
# It also backs up specified existing config files (e.g., .zshrc, .bashrc) before stowing.

echo "Running dotfiles install.sh..."

# --- Configuration ---
# Add any files in $HOME that should be backed up before stow runs
FILES_TO_BACKUP=(".zshrc" ".bashrc")
# --- End Configuration ---

# Ensure stow is available
# (Stow installation logic remains the same as before)
if ! command -v stow &> /dev/null
then
    echo "Stow not found, attempting to install..."
    # Check if sudo is available and user has sudo rights without password
    if command -v sudo &> /dev/null && sudo -n true 2>/dev/null; then
        # Update package list in case it's stale
        sudo apt-get update -y
        sudo apt-get install -y stow
    else
        echo "Warning: sudo not available or requires a password. Trying to install stow without sudo."
        # Try installing without sudo (might fail depending on permissions)
        apt-get update -y
        apt-get install -y stow
    fi

    # Verify installation
    if ! command -v stow &> /dev/null
    then
        echo "Error: Failed to install stow. Please install it manually and ensure it's in your PATH."
        exit 1
    fi
fi

# Navigate to the dotfiles directory (where this script is located)
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPT_DIR" || { echo "Error: Could not navigate to script directory '$SCRIPT_DIR'"; exit 1; }

echo "Current directory: $(pwd)" # Confirm we are in the dotfiles directory

# --- Backup existing config files ---
echo "Checking for existing configuration files to back up: ${FILES_TO_BACKUP[*]}"

for FILENAME in "${FILES_TO_BACKUP[@]}"; do
    TARGET_FILE="$HOME/$FILENAME"
    if [ -e "$TARGET_FILE" ]; then # Check if target exists (could be file or symlink)
        if [ ! -L "$TARGET_FILE" ]; then # Check if it's NOT a symlink (only backup regular files/dirs)
            TIMESTAMP=$(date +%H_%M_%S) # Generate timestamp for this specific file backup
            BACKUP_FILE="${TARGET_FILE}_bak_${TIMESTAMP}"
            echo "Found existing file $TARGET_FILE. Backing it up to $BACKUP_FILE..."
            # Attempt to move the file
            mv "$TARGET_FILE" "$BACKUP_FILE"
            if [ $? -eq 0 ]; then
                echo "Backup of $FILENAME successful."
            else
                # Critical Error: If backup fails, abort to prevent data loss by stow
                echo "Error: Failed to back up $TARGET_FILE. Aborting stow."
                exit 1
            fi
        else
             # It exists, but it's a symlink. Assume it's managed by stow or similar.
             echo "Found existing symlink at $TARGET_FILE. Assuming it's managed. Skipping backup."
             # Optional: You could uncomment the next lines to remove existing symlinks
             # echo "Removing existing symlink $TARGET_FILE..."
             # rm "$TARGET_FILE"
             # if [ $? -ne 0 ]; then
             #    echo "Error: Failed to remove existing symlink $TARGET_FILE. Aborting."
             #    exit 1
             # fi
        fi
    # else
        # File doesn't exist, no action needed. Uncomment below for verbose output.
        # echo "File $TARGET_FILE does not exist. No backup needed."
    fi
done
# --- End Backup Section ---

# Run stow to create symlinks for all packages in the current directory
# The target directory is implicitly $HOME (stow's default parent directory of the target)
echo "Running stow for all packages in $(pwd)..."
# The '*' will expand to all files and directories in the current directory ($SCRIPT_DIR)
# Stow interprets these as packages to link into the parent directory ($HOME)
stow * -t "$HOME" # Explicitly set target directory for clarity

# Check if stow command was successful
if [ $? -eq 0 ]; then
    echo "Stow successfully executed."
else
    echo "Stow encountered errors. Please check the output above."
    # Consider exiting with an error code if stow fails
    # exit 1
fi

echo "Dotfiles installation script finished."

exit 0 # Indicate success
