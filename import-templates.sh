#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/Raphael-JF/Latex-templates.git"
TMP_DIR="$(mktemp -d)"

read -r -p "Quel template souhaitez-vous importer ? Ils seront importés dans le répertoire courant :\n> " TEMPLATE_CHOICE
read -r -p "Où souhaitez-vous importer le template ?\n> " DEST_DIR

case "$TEMPLATE_CHOICE" in
	algonum)
        NAME="rapport-algonum"
		;;
	cours)
        NAME="cours"
		;;
    alveus)
        NAME="alveus"
        ;;
	*)
		echo "❌ Choix invalide. Utilisez 'algonum', 'cours' ou 'alveus'."
		exit 1
		;;
esac
TEMPLATE_DIR="$TMP_DIR/$NAME"
git clone --depth=1 "$REPO_URL" "$TMP_DIR"

cp -r "$TEMPLATE_DIR" "$DEST_DIR"
cp -r "$TMP_DIR/backend" "$DEST_DIR/"

if [ -f "$TMP_DIR/Makefile" ]; then
	cp "$TMP_DIR/Makefile" "$DEST_DIR/Makefile"
elif [ -f "$TEMPLATE_DIR/Makefile" ]; then
	cp "$TEMPLATE_DIR/Makefile" "$DEST_DIR/Makefile"
fi

rm -rf "$TMP_DIR"

echo "✅ Templates importés"
