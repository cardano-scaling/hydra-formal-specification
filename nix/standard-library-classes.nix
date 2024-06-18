{ lib, mkDerivation, fetchFromGitHub, standard-library }:

mkDerivation rec {
  version = "2.0";
  pname = "standard-library-classes";

  src = fetchFromGitHub {
    owner = "omelkonian";
    repo = "agda-stdlib-classes";
    rev = "v${version}";
    sha256 = "sha256-PcieRRnctjCzFCi+gUYAgyIAicMOAZPl8Sw35fZdt0E=";
  };

  buildInputs = [ standard-library ];

  libraryFile = "agda-stdlib-classes.agda-lib";
  everythingFile = "Classes.agda";

  meta = { };
}

