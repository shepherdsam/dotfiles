#!/bin/bash
# install.sh - dotfiles installer

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="$DOTFILES_DIR/.config"
CONFIG_DEST="$HOME/.config"

# Sanity check (now that DOTFILES_DIR is dynamic)
if [ ! -d "$CONFIG_SRC" ]; then
    echo "Error: $CONFIG_SRC not found. Run this script from inside the dotfiles repo."
    exit 1
fi

# Create .config if it doesn't exist
mkdir -p "$CONFIG_DEST"

# Function to create symlink (idempotent + source check)
link() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        echo "Warning: source does not exist, skipping: $src"
        return 0
    fi

    # Already correctly linked?
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "Already linked: $dest"
        return 0
    fi

    # Backup anything that exists at dest (file, dir, or wrong symlink)
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up existing: $dest → $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    ln -s "$src" "$dest"
    echo "Linked: $dest"
}

echo "Creating symlinks..."

# Symlink entire .config subfolders
shopt -s nullglob
for dir in "$CONFIG_SRC"/*/; do
    if [ -d "$dir" ]; then
        dir="${dir%/}"                 # strip trailing slash for clean symlink targets
        app=$(basename "$dir")
        link "$dir" "$CONFIG_DEST/$app"
    fi
done

# Symlink root-level dotfiles
link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
# Add more as needed:
# link "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"

# Symlink executables from bin/ (theme switcher, etc.)
if [ -d "$DOTFILES_DIR/bin" ]; then
    mkdir -p "$HOME/bin"
    shopt -s nullglob
    for script in "$DOTFILES_DIR"/bin/*; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            link "$script" "$HOME/bin/$(basename "$script")"
        fi
    done
fi

echo "Dotfiles installation completed!"
echo "You may want to restart your terminal or run: source ~/.zshrc"
