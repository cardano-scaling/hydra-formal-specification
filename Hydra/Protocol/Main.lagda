\documentclass{book}
\usepackage{titlesec}
\usepackage{etoolbox}
\usepackage{lipsum}

\include{preamble}

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
open import Ledger.Prelude hiding (fromList; ε); open Computational
open import ScriptVerification.Prelude

module Hydra.Protocol.Main where

scriptImp : ScriptImplementation String String
scriptImp = record { serialise = id ;
                     deserialise = λ x → just x ;
                     toData' = λ x → "dummy" }

open import ScriptVerification.LedgerImplementation String String scriptImp
open import ScriptVerification.Lib String String scriptImp
open import Ledger.ScriptValidation SVTransactionStructure SVAbstractFunctions
open import Data.Empty
open import Ledger.Utxo SVTransactionStructure SVAbstractFunctions
open import Ledger.Transaction
open TransactionStructure SVTransactionStructure
open import Ledger.Types.Epoch
open EpochStructure SVEpochStructure
open Implementation
open import Ledger.Utxo.Properties SVTransactionStructure SVAbstractFunctions
open import Ledger.Utxow.Properties SVTransactionStructure SVAbstractFunctions

-- true if redeemer is "Hello World"
helloWorld' : Maybe String → Maybe String → Bool
helloWorld' _ (just s) = ⌊ (s ≟ "Hello World") ⌋
helloWorld' _ _ = false

helloWorld : PlutusScript
helloWorld = 777 , applyScript helloWorld'


initEnv : UTxOEnv
initEnv = createEnv 0

initTxOut : TxOut
initTxOut = inj₁ (record { net = tt ;
                           pay = ScriptObj 777 ;
                           stake = ScriptObj 777 })
                           , 10 , nothing , nothing

script : TxIn × TxOut
script = (6 , 6) , initTxOut

initState : UTxO
initState = fromList' (script ∷ (createInitUtxoState 5 1000000000000))

succeedTx : Tx
succeedTx = record { body = record
                         { txins = Ledger.Prelude.fromList ((6 , 6) ∷ (5 , 5) ∷ [])
                         ; refInputs = ∅
                         ; txouts = fromListIx ((6 , initTxOut)
                                               ∷ (5
                                                 , ((inj₁ (record { net = tt ;
                                                                    pay = KeyHashObj 5 ;
                                                                    stake = KeyHashObj 5 }))
                                                 , (1000000000000 - 10000000000) , nothing , nothing))
                                               ∷ [])
                         ; txfee = 10000000000
                         ; mint = 0
                         ; txvldt = nothing , nothing
                         ; txcerts = []
                         ; txwdrls = ∅
                         ; txvote = []
                         ; txprop = []
                         ; txdonation = 0
                         ; txup = nothing
                         ; txADhash = nothing
                         ; txNetworkId = just tt
                         ; curTreasury = nothing
                         ; txsize = 10
                         ; txid = 7
                         ; collateral = Ledger.Prelude.fromList ((5 , 5) ∷ [])
                         ; reqSigHash = ∅
                         ; scriptIntHash = nothing
                         } ;
                wits = record { vkSigs = fromListᵐ ((5 , 12) ∷ []) ;
                                -- signature now is first number + txId ≡ second number
                                -- first number is needs to be the id for the script
                                scripts = Ledger.Prelude.fromList ((inj₂ helloWorld) ∷ []) ;
                                txdats = ∅ ;
                                txrdmrs = fromListᵐ (((Spend , 6) , "Hello World" , (5 , 5)) ∷ []) } ;
                isValid = true ;
                txAD = nothing }

failTx : Tx
failTx = record { body = record
                         { txins = Ledger.Prelude.fromList ((6 , 6) ∷ [])
                         ; refInputs = ∅
                         ; txouts = ∅
                         ; txfee = 10
                         ; mint = 0
                         ; txvldt = nothing , nothing
                         ; txcerts = []
                         ; txwdrls = ∅
                         ; txvote = []
                         ; txprop = []
                         ; txdonation = 0
                         ; txup = nothing
                         ; txADhash = nothing
                         ; txNetworkId = just tt
                         ; curTreasury = nothing
                         ; txsize = 10
                         ; txid = 7
                         ; collateral = ∅
                         ; reqSigHash = ∅
                         ; scriptIntHash = nothing
                         } ;
                wits = record { vkSigs = ∅ ;
                                scripts = Ledger.Prelude.fromList ((inj₂ helloWorld) ∷ []) ;
                                txdats = ∅ ;
                                txrdmrs = fromListᵐ (((Spend , 6) , "Hello World!" , (5 , 5)) ∷ []) } ;
                isValid = true ;
                txAD = nothing }

succeedState : List (Script × List Implementation.Data × Implementation.ExUnits × Implementation.CostModel)
succeedState = (collectPhaseTwoScriptInputs (UTxOEnv.pparams initEnv) succeedTx initState)

evalSucceedScript : Bool
evalSucceedScript = evalScripts succeedTx succeedState

failState : List (Script × List Implementation.Data × Implementation.ExUnits × Implementation.CostModel)
failState = (collectPhaseTwoScriptInputs (UTxOEnv.pparams initEnv) failTx initState)

evalFailScript : Bool
evalFailScript = evalScripts failTx failState

opaque
  unfolding collectPhaseTwoScriptInputs
  unfolding setToList
  unfolding Computational-UTXO
  unfolding outs

  _ : notEmpty succeedState ≡ ⊤
  _ = refl

  -- need to check that the state is non-empty otherwise evalScripts will always return true
  _ : notEmpty succeedState ≡ ⊤
  _ = refl

  _ : evalSucceedScript ≡ true
  _ = refl

  _ : notEmpty failState ≡ ⊤
  _ = refl

  _ : evalFailScript ≡ false
  _ = refl

  -- Compute the result of running the UTXO rules on the succeedTx transaction
  succeedExample : ComputationResult String UTxOState
  succeedExample = UTXO-step initEnv ⟦ initState , 0 , ∅ , 0 ⟧ᵘ  succeedTx

  _ : isSuccess succeedExample ≡ true
  _  = refl

  -- Compute the result of running the UTXO rules on the failTx transaction
  failExample : ComputationResult String UTxOState
  failExample = UTXO-step initEnv ⟦ initState , 0 , ∅ , 0 ⟧ᵘ  failTx

  _ : failExample ≡ failure "¬ feesOK pp tx utxo ≡ true"
  _ = refl


open import Effect.Monad
open import Effect.Monad.Identity
open import Effect.Monad.Identity.Instances
open import Effect.Monad.Reader
open import Effect.Monad.Reader.Instances

data CounterParty : Set where
  Client : CounterParty
  Chain : CounterParty

data Message : Set where
  Init : Message
  NewTx : Message

open RawMonad {{...}}
open RawMonadReader {{...}}

on_from_,_ : Message -> CounterParty -> Reader String String -> ComputationResult String String
on x from f , k = success $ runReader k "foo"

f : ComputationResult String String
f = on Init from Client , do
      ask

_ : f ≡ success "foo"
_ = refl

\end{code}
\subsection{Test Subsection}

\paragraph{}% acts like a numbered subsection without title
\lipsum[2]
\subsubsection{Variables}
\begin{code}

open import Agda.Builtin.Nat public
  using (zero; suc) renaming (Nat to ℕ)

ℍ = String

variable
  ν^ : ℕ
  ν⁻ : ℕ
  s^ : ℕ
  s⁻ : ℕ
  σ⁻ : ℍ
  𝓤^ : List UTxO
  𝓤⁻ : List UTxO
  Σ^ : List (ℕ × ℍ)
  𝓛^ : List UTxO
  𝓣^ : List Tx
  tx𝜔 : Maybe Tx

\end{code}
\subparagraph{}% acts like a numbered subsubsection without title
\lipsum[2]
\subsubsection{Test Subsubsection}
\lipsum[2]
\subparagraph{}% acts like a numbered subsubsection without title
\lipsum[2]

\end{document}
