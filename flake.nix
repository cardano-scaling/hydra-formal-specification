{

  description = "Hydra Formal Specification in Agda";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    formal-ledger = {
      url = "github:IntersectMBO/formal-ledger-specifications";
      flake = false;
    };
    hydra-coding-standards.url = "github:cardano-scaling/hydra-coding-standards/0.6.6";
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      imports = [
        inputs.hydra-coding-standards.flakeModule
      ];
      perSystem = { pkgs, ... }:
        let
          agdaPackages = pkgs.callPackage ./nix/initial-packages.nix {
            inherit (pkgs.haskellPackages) Agda;
            inherit (inputs) nixpkgs;
          };
          agdaLibraries = with agdaPackages;
            [
              abstract-set-theory
              formal-ledger
              standard-library
              standard-library-classes
              standard-library-meta
            ];
        in
        rec {
          coding.standards.hydra.enable = true;
          packages = {
            hydra-spec-pdf = agdaPackages.mkDerivation {
              pname = "hydra-spec.pdf";
              version = "0.0.1";
              nativeBuildInputs = with pkgs; [
                (agdaPackages.withPackages agdaLibraries)
                (haskellPackages.ghcWithPackages (p: [ p.shake ]))
                inkscape
                texlive.combined.scheme-full
              ];
              meta = { };
              src = ./.;
              buildPhase = ''
                shake
              '';
              installPhase = ''
                mkdir $out
                cp _build/hydra-spec.pdf $out/hydra-spec.pdf
              '';
            };

            default = packages.hydra-spec-pdf;
          };
        };
    };
}
