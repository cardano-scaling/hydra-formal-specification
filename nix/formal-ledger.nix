{ lib, mkDerivation, fetchFromGitHub, standard-library, standard-library-classes, standard-library-meta }:

mkDerivation rec {
  version = "0.2.0";
  pname = "formal-ledger";

  src = (fetchFromGitHub {
    owner = "IntersectMBO";
    repo = "formal-ledger-specifications";
    rev = "b1c45bca6da88db0c007a6bbd7eff9dd1892aa44";
    sha256 = "sha256-Mzem6L5GkNbNt78XG7qnrz6+mWOpXRqGG8aEiXxMLuA=";
  }) + "/src";

  buildInputs = [ standard-library standard-library-classes standard-library-meta ];

  meta = { };
}

