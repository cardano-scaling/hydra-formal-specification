{ self, inputs, ... }: {
  imports = [
    inputs.hydra-coding-standards.flakeModule
  ];
  perSystem = { pkgs, ... }:
    let
      agdaPackages = pkgs.callPackage "${self}/pkgs/initial-packages.nix" {
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
          src = self;
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
}
