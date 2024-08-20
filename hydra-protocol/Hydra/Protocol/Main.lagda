\documentclass[11pt]{article}

\usepackage{amsfonts,amsmath,amssymb,amsthm}
\usepackage[normalem]{ulem} % temporary for strikeout math
\usepackage{enumerate}
\usepackage[shortlabels,inline]{enumitem}
\usepackage{wrapfig}

\usepackage[lined,noend]{algorithm2e}
\usepackage{tabularx}
\usepackage{colortbl}
\usepackage{adjustbox}
\DontPrintSemicolon

\PassOptionsToPackage{hyphens}{url}
\usepackage{fullpage}
\usepackage{hyperref}
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
\usepackage[many]{tcolorbox}    	% for COLORED BOXES

\usepackage{authblk}

% footnotes in table and tabular
\usepackage{footnote}
\makesavenoteenv{tabular}
\makesavenoteenv{table}
\makesavenoteenv{figure}

\usepackage{stmaryrd} % fancy double square brackets
\usepackage{todonotes}

\setcounter{tocdepth}{2} % Override LLNCS

\usepackage{agda}

\include{Hydra/Protocol/Macros}

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
