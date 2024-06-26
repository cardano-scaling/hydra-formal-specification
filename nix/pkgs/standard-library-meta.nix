{ lib, mkDerivation, fetchFromGitHub, standard-library, standard-library-classes }:

mkDerivation rec {
  version = "2.0";
  pname = "agda-stdlib-meta";

  src = fetchFromGitHub {
    owner = "input-output-hk";
    repo = "stdlib-meta";
    rev = "4fc4b1ed6e47d180516917d04be87cbacbf7d314";
    sha256 = "T+9vwccbDO1IGBcGLjgV/fOt+IN14KEV9ct/J6nQCsM=";
  };

  buildInputs = [ standard-library standard-library-classes ];

  libraryFile = "agda-stdlib-meta.agda-lib";
  everythingFile = "Main.agda";

  meta = { };
}

