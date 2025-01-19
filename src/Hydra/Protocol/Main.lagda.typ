#import "../../conf.typ": conf
#set heading(numbering: "1.")
#show heading: set block(spacing: 1.5em)
#set block(below: 1.5em)
#show: conf.with(
  title: [
    Hydra Head V1 Specification: Coordinated Head Protocol
  ],
  authors: (
    (
      name: "Sebastian Nagel",
      email: "sebastian.nagel@iohk.io",
    ),
    (
      name: "Sasha Bogicevic",
      email: "sasha.bogicevic@iohk.io",
    ),
    (
      name: "Franco Testagrossa",
      email: "franco.testagrossa@iohk.io",
    ),
    (
      name: "Daniel Firth",
      email: "daniel.firth@iohk.io",
    ),
  )
)

/*
```
module Hydra.Protocol.Main where

import Hydra.Protocol.Throwaway
```
*/

#pagebreak()
#include "Introduction.lagda.typ"
#pagebreak()
#include "Overview.lagda.typ"
#pagebreak()
#include "Preliminaries.lagda.typ"
#pagebreak()
#include "Setup.lagda.typ"
#pagebreak()
#include "OnChain.lagda.typ"
#pagebreak()
#include "OffChain.lagda.typ"
#pagebreak()
#include "Security.lagda.typ"
#pagebreak()

#bibliography("../../short.bib")
