\documentclass[11pt]{article}

\include{preamble}
\include{macros}

\begin{document}

\begin{titlepage}

\vspace*{\fill} % Add whitespace above to center the title page content

\begin{center}

{\LARGE Hydra Protocol Specification}\\ [1.5cm]

Date: \today

\end{center}

\vspace*{\fill}

\end{titlepage}

\tableofcontents

\begin{code}[hide]
module Hydra.Protocol.Main where

open import Hydra.Protocol.Throwaway
\end{code}

\input{Hydra/Protocol/Introduction}
\input{Hydra/Protocol/Overview}
\input{Hydra/Protocol/Preliminaries}
\input{Hydra/Protocol/Setup}
\input{Hydra/Protocol/OnChain}
\input{Hydra/Protocol/OffChain}
\input{Hydra/Protocol/Security}
\input{Hydra/Protocol/Throwaway}

\bibliographystyle{plain}
\bibliography{short}

\end{document}
