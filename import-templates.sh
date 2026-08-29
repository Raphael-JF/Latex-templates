#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/Raphael-JF/Latex-templates.git"
TMP_ROOT_DIR="$(mktemp -d)"

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
read -r -p ">" TEMPLATE_DIR
echo "Où souhaitez-vous importer le template ?"
read -r -p ">" DEST_DIR

case "$TEMPLATE_DIR" in
	algonum)
		;;
	cours)
		;;
  alveus)
    ;;
  graphes)
    ;;
  projet)
    ;;
	*)
		echo "❌ Choix invalide. Utilisez 'algonum', 'cours', 'alveus' ou 'graphes'."
		exit 1
		;;
esac
git clone --depth=1 "$REPO_URL" "$TMP_ROOT_DIR"

cp -r "$TMP_ROOT_DIR/$TEMPLATE_DIR" "$DEST_DIR"
cp -r "$TMP_ROOT_DIR/backend" "$DEST_DIR/"

# prioritize Makefile from the template directory if it exists, otherwise use the one from the temporary directory
if [ -f "$TMP_ROOT_DIR/Makefile" ]; then
	cp "$TMP_ROOT_DIR/Makefile" "$DEST_DIR"
elif [ -f "$TMP_ROOT_DIR/$TEMPLATE_DIR/Makefile" ]; then
	cp "$TMP_ROOT_DIR/$TEMPLATE_DIR/Makefile" "$DEST_DIR"
fi



rm -rf "$TMP_ROOT_DIR"

echo "✅ Templates importés"
