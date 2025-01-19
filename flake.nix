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
          packages = {
            hydra-spec-pdf = agdaPackages.mkDerivation {
              pname = "hydra-spec.pdf";
              version = "0.0.1";
              nativeBuildInputs = with pkgs; [
                (agdaPackages.withPackages agdaLibraries)
                (haskellPackages.ghcWithPackages (p: [ p.shake ]))
                typst
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
            checks.typecheck = agdaPackages.mkDerivation {
              pname = "hydra-spec-typecheck";
              version = "0.0.1";
              nativeBuildInputs = with pkgs; [
                (agdaPackages.withPackages agdaLibraries)
                (haskellPackages.ghcWithPackages (p: [ p.shake ]))
              ];
              meta = { };
              src = ./.;
              buildPhase = ''
                shake check
              '';
            };
        };
    };
}
