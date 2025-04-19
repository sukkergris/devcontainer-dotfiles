#!/bin/bash

# Set the PATH
export PATH="$HOME/.local/bin:$PATH"

# Load all files from ~/.config/shell-common/ if the directory exists

# Check if the target directory exists first
if [ -d "$HOME/.config/shell-common" ]; then

  # Set the nullglob option so that if no files match the pattern,
  # the loop doesn't run with the literal pattern string.
  shopt -s nullglob # <-- Bash equivalent of setopt nullglob

  # Loop through all files in the specified directory ~/.config/shell-common/
  # The '*' here means all files and directories directly inside ~/.config/shell-common/
  for config_file in "$HOME/.config/shell-common/"*; do

    # Check if the found item is a regular file before sourcing
    if [ -f "$config_file" ]; then
      source "$config_file" # Sources the file
    fi
  done

  # Unset the nullglob option
  shopt -u nullglob # <-- Bash equivalent of unsetopt nullglob

fi # <--- Matches the initial 'if [ -d ... ]'