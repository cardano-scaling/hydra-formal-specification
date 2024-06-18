{

  description = "Hydra Formal Specification in Agda";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
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
          agdaPackages = pkgs.callPackage ./initial-packages.nix { Agda = pkgs.haskellPackages.Agda; nixpkgs = inputs.nixpkgs; };
        in
        rec {
          packages = {
            hydra-agda-spec = agdaPackages.mkDerivation { 
              pname = "hydra-formal-specification";
              version = "0.0.1";
              src = ./.;
              buildInputs = [ agdaPackages.standard-library agdaPackages.formal-ledger ];
              meta = { };
              buildPhase = ''
                agda --latex Hydra/Protocol/Main.lagda
              '';
              installPhase = ''
                mkdir $out
                cp -r latex/* $out/
              '';
            };

            default = pkgs.stdenv.mkDerivation {
              pname = "hydra-formal-specification";
              version = "0.0.1";
              src = ./.;
              nativeBuildInputs = with pkgs; [
                texlive.combined.scheme-full
              ];
              buildInputs = [ packages.hydra-agda-spec ];
              buildPhase = ''
                cp ${packages.hydra-agda-spec}/* -r .
                HOME=./. pdflatex Hydra/Protocol/Main.tex
                HOME=./. pdflatex Hydra/Protocol/Main.tex
                HOME=./. pdflatex Hydra/Protocol/Main.tex
              '';
              installPhase = ''
                mkdir $out
                cp Main.pdf $out/hydra-protocol.pdf
              '';
            };
          };
        };
    };
}
