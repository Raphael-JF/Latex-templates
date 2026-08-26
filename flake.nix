{
  description = "Latex templates development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        templateMap = {
          algonum = "rapport-algonum";
          cours = "cours";
          alveus = "alveus";
          graphes = "rapport-graphes";
          projet = "rapport-projet";
        };
        importTemplates = pkgs.writeShellApplication {
          name = "import-templates";
          runtimeInputs = with pkgs; [ coreutils ];
          text = ''
            set -euo pipefail

            SOURCE_ROOT="${self}"

            if [ "$#" -ge 2 ]; then
              TEMPLATE_CHOICE="$1"
              DEST_DIR="$2"
            else
              echo "Les templates disponibles sont :"
              echo "  - algonum : Un template pour les rapports d'algorithmique numérique"
              echo "  - cours    : Un template pour les cours et notes de cours"
              echo "  - alveus   : Un template pour les projets Alveus"
              echo "  - graphes  : Un template pour les rapports d'algorithmique des graphes"
              echo "  - projet   : Un template pour les gros projets de programmation"
              echo "---------------------------------"
              read -r -p "Quel template souhaitez-vous importer ? " TEMPLATE_CHOICE
              read -r -p "Où souhaitez-vous importer le template ? " DEST_DIR
            fi

            case "$TEMPLATE_CHOICE" in
              ${builtins.concatStringsSep "\n              " (builtins.map (choice: "${choice}) NAME=\"${templateMap.${choice}}\" ;;") (builtins.attrNames templateMap))}
              *)
                echo "❌ Choix invalide. Utilisez : ${builtins.concatStringsSep ", " (builtins.attrNames templateMap)}"
                exit 1
                ;;
            esac

            mkdir -p "$DEST_DIR"
            cp -r "$SOURCE_ROOT/$NAME" "$DEST_DIR/"
            cp -r "$SOURCE_ROOT/backend" "$DEST_DIR/"

            if [ -f "$SOURCE_ROOT/Makefile" ]; then
              cp "$SOURCE_ROOT/Makefile" "$DEST_DIR/"
            elif [ -f "$SOURCE_ROOT/$NAME/Makefile" ]; then
              cp "$SOURCE_ROOT/$NAME/Makefile" "$DEST_DIR/"
            fi

            echo "✅ Template '$TEMPLATE_CHOICE' importé dans '$DEST_DIR'"
          '';
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            texliveFull
            texlab
            gnumake
          ];
        };

        packages.default = importTemplates;
        apps.default = flake-utils.lib.mkApp { drv = importTemplates; };
      });
}
