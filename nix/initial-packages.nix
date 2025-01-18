{ pkgs, lib, newScope, Agda, nixpkgs }:

let
  mkAgdaPackages = Agda: lib.makeScope newScope (mkAgdaPackages' Agda);
  mkAgdaPackages' = Agda: self:
    let
      inherit (self) callPackage;
      inherit (callPackage "${nixpkgs}/pkgs/build-support/agda" {
        inherit Agda self;
        inherit (pkgs.haskellPackages) ghcWithPackages;
      }) withPackages mkDerivation;
    in
    {
      inherit withPackages mkDerivation;

      lib = lib.extend (final: prev: import "${nixpkgs}/pkgs/build-support/agda/lib.nix" { lib = prev; });

      agda = withPackages [ ];

      abstract-set-theory = callPackage ./pkgs/abstract-set-theory.nix { };

      formal-ledger = callPackage ./pkgs/formal-ledger.nix { };

      standard-library = callPackage ./pkgs/standard-library.nix { };
      inherit (pkgs.haskellPackages) ghcWithPackages;

      standard-library-classes = callPackage ./pkgs/standard-library-classes.nix { };

      standard-library-meta = callPackage ./pkgs/standard-library-meta.nix { };

    };
in
mkAgdaPackages Agda
