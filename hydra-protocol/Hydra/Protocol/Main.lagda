\documentclass[11pt]{article}
\usepackage{titlesec}
\usepackage{etoolbox}
\usepackage{lipsum}
\usepackage{todonotes}
\usepackage{polytable}

\usepackage[many]{tcolorbox}
\usepackage{amsfonts,amsmath,amssymb,amsthm}
\usepackage[normalem]{ulem} % temporary for strikeout math
\usepackage{environ}
\usepackage{enumerate}
\usepackage[shortlabels,inline]{enumitem}
\usepackage{wrapfig}
\usepackage[lined,noend]{algorithm2e}
\usepackage{tabularx}
\usepackage{colortbl}
\usepackage{adjustbox}
\usepackage{fullpage}
\usepackage{xcolor}
\usepackage{xifthen}
% Keep figures in same section
\usepackage[section]{placeins}
\usepackage{pifont}
\usepackage{multirow}
\usepackage{tikz}
\usetikzlibrary{automata, arrows}
\usepackage{pgfplots}
\usepackage[framemethod=tikz]{mdframed} % and thus tikz
\usepackage[font=small]{caption}
\usepackage[many]{tcolorbox}      % for COLORED BOXES
\usepackage{agda}

% NOTE: from formal-ledger-specifications
% \include{preamble}
\include{Hydra/Protocol/Macros}

\setcounter{secnumdepth}{5}
\setcounter{tocdepth}{2}
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
