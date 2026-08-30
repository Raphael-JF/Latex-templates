#!/usr/bin/env bash
set -euo pipefail

TEMPLATES_DIR="@TEMPLATES_DIR@"

if [ "$#" -ne 2 ]; then
    echo "Usage: latexTemplate <template> <destination>"
    exit 1
fi

TEMPLATE="$1"
DEST="$2"

if [ ! -d "$TEMPLATES_DIR/$TEMPLATE" ] || [ "$TEMPLATE" = "backend" ]; then
    echo "❌ Template inconnu : $TEMPLATE"
    exit 1
fi

mkdir -p "$DEST"

cp -r "$TEMPLATES_DIR/$TEMPLATE" "$DEST/"
cp -r "$TEMPLATES_DIR/backend" "$DEST/"
cp "$TEMPLATES_DIR/to-flake.nix" "$DEST/flake.nix"

if [ -f "$TEMPLATES_DIR/Makefile" ]; then
    cp "$TEMPLATES_DIR/Makefile" "$DEST/"
elif [ -f "$TEMPLATES_DIR/$TEMPLATE/Makefile" ]; then
    cp "$TEMPLATES_DIR/$TEMPLATE/Makefile" "$DEST/"
fi

echo "✅ Template '$TEMPLATE' importé dans '$DEST'."
