{ pkgs, lib, newScope, Agda, nixpkgs }:

let
  mkAgdaPackages = Agda: lib.makeScope newScope (mkAgdaPackages' Agda);
  mkAgdaPackages' = Agda: self: let
    inherit (self) callPackage;
    inherit (callPackage "${nixpkgs}/pkgs/build-support/agda" {
      inherit Agda self;
      inherit (pkgs.haskellPackages) ghcWithPackages;
    }) withPackages mkDerivation;
  in {
    inherit mkDerivation;

    lib = lib.extend (final: prev: import "${nixpkgs}/pkgs/build-support/agda/lib.nix" { lib = prev; });

    agda = withPackages [];

    formal-ledger = callPackage ./nix/formal-ledger.nix { };

    standard-library = callPackage ./nix/standard-library.nix { };
      inherit (pkgs.haskellPackages) ghcWithPackages;

    standard-library-classes = callPackage ./nix/standard-library-classes.nix { };

    standard-library-meta = callPackage ./nix/standard-library-meta.nix { };

  };
in mkAgdaPackages Agda
