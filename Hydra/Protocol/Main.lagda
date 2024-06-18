\documentclass{book}
\usepackage{titlesec}
\usepackage{etoolbox}
\usepackage{lipsum}
\usepackage{agda}

\setcounter{secnumdepth}{5}
\setcounter{tocdepth}{1}
\renewcommand\thesection{\arabic{section}}


% this length controls tha hanging indent for titles
% change the value according to your needs
\newlength\titleindent
\setlength\titleindent{2cm}

\pretocmd{\paragraph}{\stepcounter{subsection}}{}{}
\pretocmd{\subparagraph}{\stepcounter{subsubsection}}{}{}

\titleformat{\chapter}[block]
  {\normalfont\huge\bfseries}{}{0pt}{\hspace*{-\titleindent}}

\titleformat{\section}
  {\normalfont\Large\bfseries}{\llap{\parbox{\titleindent}{\thesection\hfill}}}{0em}{}

\titleformat{\subsection}
  {\normalfont\large}{\llap{\parbox{\titleindent}{\thesubsection\hfill}}}{0em}{\bfseries}

\titleformat{\subsubsection}
  {\normalfont\normalsize}{\llap{\parbox{\titleindent}{\thesubsubsection}}}{0em}{\bfseries}

\titleformat{\paragraph}[runin]
  {\normalfont\large}{\llap{\parbox{\titleindent}{\thesubsection\hfill}}}{0em}{}

\titleformat{\subparagraph}[runin]
  {\normalfont\normalsize}{\llap{\parbox{\titleindent}{\thesubsubsection\hfill}}}{0em}{}

\titlespacing*{\chapter}{0pt}{0pt}{20pt}
\titlespacing*{\subsubsection}{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}
\titlespacing*{\paragraph}{0pt}{3.25ex plus 1ex minus .2ex}{0em}
\titlespacing*{\subparagraph}{0pt}{3.25ex plus 1ex minus .2ex}{0em}

\begin{document}

\begin{titlepage}

\vspace*{\fill} % Add whitespace above to center the title page content

\begin{center}

{\LARGE Hydra Protocol Specification}\\ [1.5cm]

Date: \today

\end{center}

\vspace*{\fill} % Add whitespace below to center the title page content

\end{titlepage}

\tableofcontents

\chapter{Test Chapter}

\section{Test Section}

\begin{code}
module Hydra.Protocol.Main where

open import Data.Nat

open import Ledger.Utxo

data HydraState : Set where
  Idle         : HydraState
  Open         : HydraState
  Closed       : HydraState
\end{code}

\subsection{Test Subsection}
\lipsum[2]
\paragraph{}% acts like a numbered subsection without title
\lipsum[2]
\subsubsection{Test Subsubsection}
\lipsum[2]
\subparagraph{}% acts like a numbered subsubsection without title
\lipsum[2]
\subsubsection{Test Subsubsection}
\lipsum[2]
\subparagraph{}% acts like a numbered subsubsection without title
\lipsum[2]

\end{document}
