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
        nativeBuildInputs = [];

        installPhase = ''
          mkdir -p "$out/bin"
          mkdir -p "$out/share/bash-completion/completions"

          substitute ${./latexTemplate.sh} \
            "$out/bin/latexTemplate" \
            --replace-fail \
            '@TEMPLATES_DIR@' \
            '${self}'

          chmod +x "$out/bin/latexTemplate"

          cat > "$out/share/bash-completion/completions/latexTemplate" <<EOF
        _latexTemplate()
        {
            local cur
            cur="\''${COMP_WORDS[COMP_CWORD]}"

            if (( COMP_CWORD == 1 )); then
                COMPREPLY=(\$(compgen -W "${templateList}" -- "\$cur"))
            fi
        }

        complete -F _latexTemplate latexTemplate
        EOF
      '';     
    };
  };
}
