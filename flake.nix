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
          agdaPackages = pkgs.callPackage ./nix/initial-packages.nix { Agda = pkgs.haskellPackages.Agda; nixpkgs = inputs.nixpkgs; };
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
              '';
              installPhase = ''
                mkdir $out
                cp -r latex/* $out/
              '';
            };

            hydra-protocol-pdf = pkgs.stdenv.mkDerivation {
              pname = "hydra-protocol.pdf";
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
                cp Main.pdf $out/hydra-protocol.pdf
              '';
            };

            default = packages.hydra-protocol-pdf;

          };
        };
    };
}
