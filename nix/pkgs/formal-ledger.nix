{ lib, mkDerivation, fetchFromGitHub, standard-library, standard-library-classes, standard-library-meta }:

mkDerivation rec {
  version = "0.2.0";
  pname = "formal-ledger";

  src = (fetchFromGitHub {
    owner = "locallycompact";
    repo = "formal-ledger-specifications";
    rev = "d2a1746ec6671ee7699487ae41b97b275160e71a";
    sha256 = "sha256-2G9VEimSLFm4j/LdM+khJ43jTRwc3q7eQEdY6w5KvD8=";
  }) + "/src";

  buildInputs = [ standard-library standard-library-classes standard-library-meta ];

  meta = { };
}

