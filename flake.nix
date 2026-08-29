{
  description = "LaTeX templates";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.latexTemplate =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        templates = pkgs.lib.filterAttrs
          (name: type:
            type == "directory" && name != "backend"
          )
          (builtins.readDir self);

        templateNames = builtins.attrNames templates;
        templateList = pkgs.lib.concatStringsSep " " templateNames;

      in pkgs.stdenv.mkDerivation {
        pname = "latexTemplate";
        version = "1.0";

        dontUnpack = true;

        nativeBuildInputs = [
          pkgs.makeWrapper
          pkgs.installShellFiles
        ];

        installPhase = ''
          mkdir -p $out/bin

          cat > $out/bin/latexTemplate <<EOF
          #!${pkgs.bash}/bin/bash
          set -euo pipefail

          if [ "\$#" -ne 2 ]; then
            echo "Usage: latexTemplate <template> <destination>"
            exit 1
          fi

          TEMPLATE="\$1"
          DEST="\$2"

          case "\$TEMPLATE" in
            ${pkgs.lib.concatStringsSep "|" templateNames})
              ;;
            *)
              echo "❌ Template inconnu : \$TEMPLATE"
              exit 1
              ;;
          esac

          mkdir -p "\$DEST"

          cp -r "${self}/\$TEMPLATE" "\$DEST/"
          cp -r "${self}/backend" "\$DEST/"

          if [ -f "${self}/Makefile" ]; then
            cp "${self}/Makefile" "\$DEST/"
          elif [ -f "${self}/\$TEMPLATE/Makefile" ]; then
            cp "${self}/\$TEMPLATE/Makefile" "\$DEST/"
          fi

          echo "✅ Template '\$TEMPLATE' importé dans '\$DEST'."
          EOF

          chmod +x $out/bin/latexTemplate

          installShellCompletion --bash <(
            cat <<EOF
          _latexTemplate() {
            local cur="\''${COMP_WORDS[COMP_CWORD]}"

            if (( COMP_CWORD == 1 )); then
              COMPREPLY=(\$(compgen -W "${templateList}" -- "\$cur"))
            fi
          }

          complete -F _latexTemplate latexTemplate
          EOF
          )
        '';
      };
  };
}
