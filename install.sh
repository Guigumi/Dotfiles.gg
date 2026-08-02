#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/config"
DEST_DIR="$HOME/.config"

backup() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup_path="${target}.bak"
        echo "  backup: $target -> $backup_path"
        cp -r "$target" "$backup_path"
    fi
}

echo "Instalando dotfiles de $DOTFILES_DIR"

mkdir -p "$DEST_DIR"

for dir in "$CONFIG_DIR"/*/; do
    [ -d "$dir" ] || continue
    name="$(basename "$dir")"
    target="$DEST_DIR/$name"

    echo "==> $name"
    backup "$target"

    if [ -L "$target" ]; then
        echo "  removendo symlink antigo: $target"
        rm "$target"
    fi

    mkdir -p "$target"
    cp -r "$dir". "$target/"
    echo "  copiado: $dir -> $target"
done

echo
echo "Instalação concluída!"
