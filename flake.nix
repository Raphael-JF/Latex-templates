{
  description = "Raphael's LaTeX templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    nixpkgs.lib.genAttrs
      [ "x86_64-linux" "aarch64-linux" ]
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # Tous les dossiers de premier niveau sont des templates,
          # sauf le dossier commun "backend".
          templates = pkgs.lib.filterAttrs
            (name: type:
              type == "directory" && name != "backend"
            )
            (builtins.readDir self);

          templateNames = builtins.attrNames templates;

          templatePattern =
            pkgs.lib.concatStringsSep "|" templateNames;

          completionWords =
            pkgs.lib.concatStringsSep " " templateNames;

          latexTemplate = pkgs.stdenv.mkDerivation {
            pname = "latexTemplate";
            version = "0.1.0";

            dontUnpack = true;

            nativeBuildInputs = [
              pkgs.installShellFiles
            ];

            installPhase = ''
              mkdir -p $out/bin

              cat > $out/bin/latexTemplate <<'EOF'
              #!${pkgs.bash}/bin/bash
              set -euo pipefail

              if [ "$#" -ne 2 ]; then
                echo "Usage: latexTemplate <template> <destination>"
                exit 1
              fi

              TEMPLATE="$1"
              DEST="$2"

              case "$TEMPLATE" in
                ${templatePattern})
                  ;;
                *)
                  echo "❌ Template inconnu : $TEMPLATE"
                  echo
                  echo "Templates disponibles :"
                  for template in ${completionWords}; do
                    echo "  - $template"
                  done
                  exit 1
                  ;;
              esac

              mkdir -p "$DEST"

              cp -r "${self}/$TEMPLATE" "$DEST/"
              cp -r "${self}/backend" "$DEST/"

              if [ -f "${self}/Makefile" ]; then
                cp "${self}/Makefile" "$DEST/"
              elif [ -f "${self}/$TEMPLATE/Makefile" ]; then
                cp "${self}/$TEMPLATE/Makefile" "$DEST/"
              fi

              echo "✅ Template '$TEMPLATE' importé dans '$DEST'."
              EOF

              chmod +x $out/bin/latexTemplate

              installShellCompletion --bash <(
                cat <<'EOF'
              _latexTemplate()
              {
                  local cur
                  cur="''${COMP_WORDS[COMP_CWORD]}"

                  if (( COMP_CWORD == 1 )); then
                      COMPREPLY=(
                          $(compgen -W "${completionWords}" -- "$cur")
                      )
                  fi
              }

              complete -F _latexTemplate latexTemplate
              EOF
              )
            '';
          };
        in
        {
          packages = {
            inherit latexTemplate;
            default = latexTemplate;
          };
        }
      );
}
