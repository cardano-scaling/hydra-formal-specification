{

  description = "Hydra Formal Specification in Agda";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    formal-ledger = {
      url = "github:IntersectMBO/formal-ledger-specifications";
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      perSystem = { pkgs, ... }:
        let
          agdaPackages = pkgs.callPackage ./nix/initial-packages.nix {
            inherit (pkgs.haskellPackages) Agda;
            inherit (inputs) nixpkgs;
          };
          buildInputs = with agdaPackages;
            [
              formal-ledger
              standard-library
              standard-library-classes
              standard-library-meta
            ];
        in
        rec {
          packages = {
            hydra-protocol-typecheck = agdaPackages.mkDerivation {
              pname = "hydra-protocol-typecheck";
              version = "0.0.1";
              src = ./hydra-protocol;
              inherit buildInputs;
              meta = { };
              buildPhase = ''
                agda Hydra/Protocol/Main.lagda
              '';
              installPhase = ''
                mkdir $out
                echo "Success" > $out/result
              '';
            };

            hydra-protocol-transliterate = agdaPackages.mkDerivation {
              pname = "hydra-protocol-transliterate";
              version = "0.0.1";
              src = ./hydra-protocol;
              inherit buildInputs;
              meta = { };
              buildPhase = ''
                mkdir latex
                cp ${inputs.formal-ledger}/src/latex/* latex/ -r
                find . -name '*.lagda' | xargs -I{} agda --transliterate --latex --latex-dir latex {}
                find . -name '*.tex' \
                    -o -name '*.pdf' \
                    -o -name '*.bib' | xargs -I{} ${pkgs.rsync}/bin/rsync -rR {} latex/
              '';
              installPhase = ''
                mkdir $out
                cp -r latex/* $out/
              '';
            };

            hydra-spec-pdf = pkgs.stdenv.mkDerivation {
              pname = "hydra-spec.pdf";
              version = "0.0.1";
              nativeBuildInputs = with pkgs; [
                texlive.combined.scheme-full
                packages.hydra-protocol-transliterate
              ];
              src = ./.;
              buildPhase = ''
                cp ${packages.hydra-protocol-transliterate}/* -r .
                HOME=./. latexmk -xelatex Hydra/Protocol/Main.tex
              '';
              installPhase = ''
                mkdir $out
                cp Main.pdf $out/hydra-spec.pdf
              '';
            };

            default = packages.hydra-spec-pdf;
          };

          devShells.default = pkgs.mkShell {
            buildInputs = [
              (agdaPackages.withPackages
                (p: [
                  p.formal-ledger
                  p.standard-library
                  p.standard-library-classes
                  p.standard-library-meta
                ]))
              (pkgs.haskellPackages.ghcWithPackages(p: with p; [shake]))
              (pkgs.texlive.combined.scheme-full)
            ];
          };
        };
    };
}
