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
        {
          packages.default = pkgs.stdenv.mkDerivation {
            pname = "hydra-formal-specification";
            version = "0.0.1";
            src = ./.;
            nativeBuildInputs = with pkgs; [
              texlive.combined.scheme-full
            ];
            buildPhase = ''
              pdflatex hydra-protocol.tex
            '';
            installPhase = ''
              mkdir $out
              cp hydra-protocol.pdf $out/
            '';
          };
        };
    };
}
