#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/Raphael-JF/Latex-templates.git"
TMP_DIR="$(mktemp -d)"

read -r -p "Quel template souhaitez-vous importer ? Ils seront importés dans le répertoire courant : " TEMPLATE_CHOICE

case "$TEMPLATE_CHOICE" in
	algonum)
		TEMPLATE_DIR="$TMP_DIR/rapport-algonum"
		;;
	cours)
		TEMPLATE_DIR="$TMP_DIR/cours"
		;;
	*)
		echo "❌ Choix invalide. Utilisez 'algonum' ou 'cours'."
		exit 1
		;;
esac

git clone --depth=1 "$REPO_URL" "$TMP_DIR"

cp -r "$TMP_DIR/backend" .
cp -r "$TEMPLATE_DIR" .

if [ -f "$TMP_DIR/Makefile" ]; then
	cp "$TMP_DIR/Makefile" .
elif [ -f "$TEMPLATE_DIR/Makefile" ]; then
	cp "$TEMPLATE_DIR/Makefile" .
fi

rm -rf "$TMP_DIR"

echo "✅ Templates importés"
