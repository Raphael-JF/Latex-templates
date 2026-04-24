#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/Raphael-JF/Latex-templates.git"
TMP_DIR="$(mktemp -d)"

templates=(
    "'algonum' : Un template pour les rapports d'algorithmique numérique"
    "'cours' : Un template pour les cours et notes de cours"
    "'alveus' : Un template pour les projets Alveus"
    "'graphes' : Un template pour les rapports d'algorithmique des graphes"
    "'projet' : Un template pour les gros projets de programmation."
)

echo "Les templates disponibles sont :"
for template in "${templates[@]}"; do
    echo "  - $template"
done
echo "---------------------------------"
echo "Quel template souhaitez-vous importer ?"
read -r -p ">" TEMPLATE_CHOICE
echo "Où souhaitez-vous importer le template ?"
read -r -p ">" DEST_DIR

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
    graphes)
        NAME="rapport-graphes"
        ;;
    projet)
        NAME="rapport-projet"
        ;;
	*)
		echo "❌ Choix invalide. Utilisez 'algonum', 'cours', 'alveus' ou 'graphes'."
		exit 1
		;;
esac
TEMPLATE_DIR="$TMP_DIR/$NAME"
git clone --depth=1 "$REPO_URL" "$TMP_DIR"

cp -r "$TEMPLATE_DIR" "$DEST_DIR"
cp -r "$TMP_DIR/backend" "$DEST_DIR/"

if [ -f "$TMP_DIR/Makefile" ]; then
	cp "$TMP_DIR/Makefile" "$DEST_DIR"
elif [ -f "$TEMPLATE_DIR/Makefile" ]; then
	cp "$TEMPLATE_DIR/Makefile" "$DEST_DIR"
fi

rm -rf "$TMP_DIR"

echo "✅ Templates importés"
