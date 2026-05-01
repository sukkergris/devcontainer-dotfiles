#!/bin/bash

# install.sh
# Executed by VS Code Dev Containers after cloning the dotfiles repository.
# Uses GNU Stow to create symlinks in the home directory.

set -euo pipefail

DOTFILES_DIR=$(dirname "$(readlink -f "$0")")
cd "$DOTFILES_DIR"

# ---------------------------------------------------------------------------
# Logging — tee all output to .devcontainer/install.log in the workspace.
# /workspaces/ is bind-mounted from host, so the log survives container rebuilds.
# Falls back to ~/.local/share/dotfiles-install/ if no workspace is found.
# ---------------------------------------------------------------------------
WORKSPACE_DIR=$(ls -d /workspaces/*/ 2>/dev/null | head -1) || true
if [ -n "$WORKSPACE_DIR" ]; then
    LOG_FILE="${WORKSPACE_DIR}.devcontainer/install.log"
else
    LOG_FILE="$HOME/.local/share/dotfiles-install/install.log"
fi
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "========================================"
echo "dotfiles install started: $(date -Iseconds)"
echo "log: $LOG_FILE"
echo "========================================"
echo "Running dotfiles install.sh from $(pwd)..."

# ---------------------------------------------------------------------------
# Ensure stow is available
# ---------------------------------------------------------------------------
if ! command -v stow &> /dev/null; then
    echo "Stow not found, attempting to install..."
    if command -v sudo &> /dev/null && sudo -n true 2>/dev/null; then
        sudo apt-get update -y && sudo apt-get install -y stow
    else
        apt-get update -y && apt-get install -y stow
    fi
    if ! command -v stow &> /dev/null; then
        echo "Error: Failed to install stow."
        exit 1
    fi
fi

# ---------------------------------------------------------------------------
# Back up existing regular files that stow will want to replace with symlinks
# ---------------------------------------------------------------------------
FILES_TO_BACKUP=(".zshrc" ".bashrc")
for f in "${FILES_TO_BACKUP[@]}"; do
    target="$HOME/$f"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        backup="${target}_bak_$(date +%H_%M_%S)"
        echo "Backing up $target → $backup"
        mv "$target" "$backup"
    fi
done

# ---------------------------------------------------------------------------
# Stow each package individually so one conflict doesn't block the rest
# ---------------------------------------------------------------------------
# Packages only useful on specific platforms or that require special handling
SKIP_ALWAYS=""          # e.g. "brew kitty" for Linux-only containers
WARN_IF_FAIL="dotnet"   # dotnet/.dotnet is empty; skip silently if ~/.dotnet exists

ERRORS=0
for pkg in */; do
    pkg="${pkg%/}"

    if echo "$SKIP_ALWAYS" | grep -qw "$pkg"; then
        echo "Skipping $pkg (excluded)"
        continue
    fi

    echo "Stowing $pkg..."
    if stow --no-folding -t "$HOME" "$pkg" 2>&1; then
        echo "  ✓ $pkg"
    else
        if echo "$WARN_IF_FAIL" | grep -qw "$pkg"; then
            echo "  ⚠ $pkg failed (non-fatal — target may already exist)"
        else
            echo "  ✗ $pkg FAILED"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

# ---------------------------------------------------------------------------
echo ""
if [ "$ERRORS" -gt 0 ]; then
    echo "Dotfiles install finished with $ERRORS error(s). See output above."
    exit 1
fi

echo "Dotfiles installation finished successfully."
