= Preliminaries
<prel>

#import("Macros.typ"): todo
#import("Macros.typ"): msSetup, msParams, msVK, msSign, msKeyGen, msSK

This section introduces notation and other preliminaries used in the remainder
of the specification.

== Notation

The specification uses set-notation based approach while also inspired
by @eutxo-2 and @eutxo. Values $a$ are in a set $a in cal("A")$,
also indicated as being of some type $a : cal("A")$, and multidimensional values are
tuples drawn from a $*$ product of multiple sets, e.g.
$(a,b) in (cal("A") * cal("B"))$. An empty set is indicated by
$emptyset$ and sets may be enumerated using $\{a_1 dots a_n\}$ notation. The $=$ operator means
equality and $arrow.l$ is explicit assignment of a variable or value to one
or more variables. Projection is used to access the elements of a tuple, e.g.
${(a,b)}^arrow.b = a$. Functions are morphisms mapping from one set to another
$x : cal("A") arrow.r f(x) : cal("B")$, where function
application of a function $f$ to an argument $x$ is written as $f(x)$.

Furthermore, given a set $cal("A")$, let
- $cal("A")^? = cal("A") union suit.diamond$ denotes an option: a value from $cal("A")$ or no value at all indicated by $bot$,
- $cal("A")^n$ be the set of all n-sized sequences over $cal("A")$,
- $cal("A")^! = union.big_(i=1)^(n in NN) cal("A")^i$ be the set of non-empty sequences over $cal("A")$, and
- $cal("A")^* = union.big_(i=0)^(n in NN) cal("A")^i$ be the set of all sequences over $cal("A")$.

With this, we further define:

- $BB = {mono("false"), mono("true")}$ are boolean values
- $NN$ are natural numbers ${0, 1, 2, dots}$
- $ZZ$ are integer numbers ${dots, -2, -1, 0, 1, 2, dots}$
- $bb(H) = union.big_{n=0}^infinity {0,1}^8n$ denotes a arbitrary string of bytes
- $sans("concat") : bb(H)^* arrow.r bb(H)$ is concatenating bytes, we also use operator $plus.circle.big$ for this
- $sans("hash") : x arrow.r bb(H)$ denotes a collision-resistant hashing function and $x^\#$ indicates the hash of $x$
- $sans("bytes") : x arrow.r bb(H)s$ denotes an invertible serialisation function mapping arbitrary data to bytes
- $a || b = sans("concat")(bb(H)(a), bb(H)(b))$ is an operator which concatenates the $bb(H)(b)$ to the $bb(H)(a)$
- Lists of values $l in cal("A")^{*}$ are written as $l = [x_1, dots, x_n]$.
  Empty lists are denoted by $[]$, the $i$th element $x_i$ is also written $l[i]$ and the length of the list is $|l| = n$.
  An underscore is also used to indicate a list of values $underline(x) = l$.
  Projection on lists are mapped to their elements, i.e. $underline(x)^arrow.b = [x_1^arrow.b, dots, x_n^arrow.b]$.
- $sans("sortOn") : i arrow.r cal("A")^* arrow.r cal("A")^*$ does sort a list of values on the $i$th projection.
- $sans("Bytes")$ is a universal data type of nested sums and products built up recursively from the base types of $ZZ$ and $bb(H)$.

== Public key multi-signature scheme
<sec:multisig>

#todo("move/merge with protocol setup and make concrete")

A multisignature scheme is a set of algorithms where
- $msSetup$ generates public parameters $msParams$, such that
- $(msVK,msSK) arrow.l msKeyGen(msParams)$ can be used to generate fresh key pairs,
/*
- $msSig arrow.l msSig (msParams),msSK(msMsg))$ signs a message $sans("msMsg")$ using key $sans("msSK")$,
- $sans("mCVK") arrow.l sans("msCombVK")(sans("msParams"),sans("msVK")L)$ aggregates a list of verification keys $sans("msVK")L$ into a single, aggregate key $sans("mCVK")$,
- $sans("msCSig") arrow.l \msComb(sans("msParams"),sans("msMsg"),sans("msVK")L,sans("msSig")L)$ aggregates a  list of signatures $sans("msSig")L$ about message $m$ into a single, aggregate signature~$sans("msCSig")$.
- $\msVfy(sans("msParams"),sans("mCVK"),sans("msMsg"),sans("msCSig")) in BB$ verifies an aggregate signature $sans("msCSig")$ of message $sans("msMsg")$ under an aggregate verification key $sans("mCVK")$.

The security definition of a multisignature scheme
from @itakura1983public,CCS:MicOhtRey01 guarantees that, if $sans("mCVK")$ is
produced from a tuple of verification keys $sans("msVK")L$ via $sans("msCombVK")$, then no
aggregate signature $sans("msCSig")$ can pass verification
$\msVfy(sans("mCVK"),sans("msMsg"),sans("msCSig"))$ unless all honest parties holding keys in
$sans("msVK")L$ signed $m$.

Note that in the following, we make the parameter~$sans("msParams")$ implicit and leave
out the $ver$ suffix for verification key such that $k = k^ver$ for better
readability.

== Extended UTxO}
<sec:eutxo>

The Hydra Head protocol is specified to work on the so-called Extended UTxO (EUTxO) ledgers
like Cardano.

The basis for EUTxO is Bitcoin's UTxO ledger
model @formal-model-of-bitcoin-transactions,Zahnentferner18-UTxO.
Intuitively, it arranges transactions in a directed acyclic graph, such as the
one in @fig:utxo-graph, where boxes represent transactions with
(red) inputs to the left and (black) outputs to the right. A dangling
(unconnected) output is an \emph{unspent transaction output (UTxO)} --- there
are two UTxOs in the figure.

#figure(
    image("Figures/utxo-graph.svg", width: 50%),
    caption: [
      Example of a plain UTxO graph
      ]
    )
<fig:utxo-graph>

The following paragraphs will give definitions of the UTxO model and it's
extension to support scripting (EUTxO) suitable for this Hydra Head protocol
specification. For a more detailed introduction to the EUTxO ledger model,
see @eutxo,@eutxo-2 and @utxo-ma.

=== Values

/*
\begin{definition}[Values]
	Values are sets that keep track of how many units of which tokens of which
	currency are available. Given a finitely supported function $\mapsto$, that
	maps keys to monoids, a value is the set of such mappings over currencies
	(minting policy identifiers), over a mapping of token names $t$ to
	quantities $q$:
	\[
		\val in \tyValue = (c : bb(H) \mapsto (t : bb(H) \mapsto q : ZZ))
	\]
	\noindent where addition of values is defined as $+$ and $\varnothing$ is the empty value.
\end{definition}

For example, the value $\{c_{1} \mapsto \{t_1 \mapsto 1, t_2 \mapsto 1\}\}$
contains tokens $t_1$ and $t_2$ of currency $c_{1}$ and addition merges
currencies and token names naturally:
\begin{align*}
	     & \{c_{1} \mapsto \{t_1 \mapsto 1, t_2 \mapsto 1\}\}                                                        \\
	+ \  & \{c_{1} \mapsto \{t_{2} \mapsto 1, t_3 \mapsto 1\}, c_{2} \mapsto \{ t_{1} \mapsto 2\}\}                  \\
	= \  & \{c_{1} \mapsto \{t_1 \mapsto 1, t_2 \mapsto 2, t_3 \mapsto 1\}, c_{2} \mapsto \{ t_{1} \mapsto 2\}\} \ .
\end{align*}

While the above definition should be sufficient for the purpose of this
specification, a full definition for finitely supported functions and values as
used here can be found in~\cite{utxo-ma}. To further improve readability, we
define the following shorthands:
- $\{t_1, \ldots, t_n\} :: c$ for a set positive single quantity assets
	      $\{c \mapsto \{t_1 \mapsto 1, \ldots, t_n \mapsto 1\}\}$,
- ${\{t_1, \ldots, t_n\}}^{-1} :: c$ for a set of negative single quantity assets
	      $\{c \mapsto \{t_1 \mapsto -1, \ldots, t_n \mapsto -1\}\}$,

- $\{c \mapsto t \mapsto q\}$ for the value entry $\{c \mapsto \{t \mapsto q\}\}$,
- $\{c \mapsto \cdot \mapsto q \}$ for any asset with currency $c$ and
	      quantity $q$ irrespective of token name.

\subsubsection{Scripts}

Validator scripts are called \emph{phase-2} scripts in the Cardano Ledger
specification (see~\cite{ledger-alonzo-spec} for a formal treatment of these). Scripts
are used for multiple purposes, but most often (and sufficient for this
specification) as a \emph{spending} or \emph{minting} policy script.

\begin{definition}[Minting Policy Script]
	A script $\mu in cal(M)$ governing whether a value can be minted (or
	burned), is a pure function with type
	\[
		\mu in cal(M) = (\rho : sans("Bytes")) arrow.r (\txContext : \tyContext) arrow.r BB,
	\]
	where $\rho in sans("Bytes")$ is the redeemer provided as part of the transaction
	being validated and $\txContext in \tyContext$ is the validation
	context.
\end{definition}

\begin{definition}[Spending Validator Script]
	A validator script $\nu in \mathcal{V}$ governing whether an output can be
	spent, is a pure function with type
	\[
		\nu in \mathcal{V} = (\delta : sans("Bytes")) arrow.r (\rho : sans("Bytes")) arrow.r (\txContext : \tyContext) arrow.rBB,
	\]
	where $\delta in sans("Bytes")$ is the datum available at the output to be spent,
	$\rho in sans("Bytes")$ is the redeemer data provided as part of the transaction
	being validated, and $\txContext in \tyContext$ is the validation
	context.
\end{definition}

\subsubsection{Transactions}
arrow.rdo{actual transactions $\mathcal{T}$ are not defined}

We define EUTxO inputs, outputs and transactions as they are available to
scripts and just enough to specify the behavior of the Hydra validator scripts.
For example outputs addresses and datums are much more complicated in the full
ledger model~\cite{eutxo-2, ledger-shelley-spec}.

\begin{definition}[Outputs]
	An output $o in \txOutputs$ stores some value $\val in \tyValue$ at some address,
	defined by the hash of a validator script $\nu^{\#} in bb(H) = \hash(\nu in \mathcal{V})$,
	and may store (reference) some data $\delta in sans("Bytes")$:
	\[
		o in \txOutputs = (\val : \tyValue \times \nu^{\#} : bb(H) \times \delta : sans("Bytes"))
	\]
\end{definition}

\begin{definition}[Output references]
	An output reference $\txOutRef in \tyOutRef$ points to an output of a
	transaction, using a transaction id (that is, a hash of the transaction body)
	and the output index within that transaction.
	\[
		\txOutRef in \tyOutRef = (bb(H) \times NN)
	\]
\end{definition}

\begin{definition}[Inputs]
	A transaction input $i in \txInputs$ is an output reference
	$\txOutRef in \tyOutRef$ with a corresponding redeemer $\rho in sans("Bytes")$:
	\[
		i in \txInputs = (\txOutRef : \tyOutRef \times \rho : sans("Bytes"))
	\]
\end{definition}

\begin{definition}[Validation Context]
	A validation context $\txContext in \tyContext$ is a view on the transaction
	to be validated:
	\[
		\txContext in \tyContext = (\tyInputs \times \tyOutputs \times \tyValue \times \mathcal{S}^{\leftrightarrow} \times \mathcal{K})
	\]
	where $\txInputs in \tyInputs$ is a \textbf{set} of inputs,
	$\txOutputs in \tyOutputs$ is a \textbf{list} of outputs,
	$\txMint in \tyValue$ is the minted (or burned) value,
	$(\txValidityMin, \txValidityMax) in \tyValidity$ are the lower and upper
	validity bounds where $\txValidityMin <= \txValidityMax$, and
	$\txKeys in \mathcal{K}$ is the set of verification keys which signed the
	transaction.
	% TODO: \tyValidity undefined, define time, periods and intervals?
\end{definition}

Informally, scripts are evaluated by the ledger when it applies a transaction to
its current state to yield a new ledger state (besides checking the transaction
integrity, signatures and ledger rules). Each validator script referenced by
an output is passed its arguments drawn from the output it locks and the
transaction context it is executed in. The transaction is valid if and only if
all scripts validate, i.e. $\mu(\rho, \txContext) = \true$ and
$\nu(\delta, \rho, \txContext) = \true$.

=== State machines and graphical notation

State machines in the EUTxO ledger model are commonly described using the
\emph{constraint emitting machine (CEM)} formalism~\cite{eutxo}, e.g.~the
original paper describes the Hydra Head protocol using this
notation~\cite{hydrahead20}. Although inspired by CEMs, this specification uses
a more direct representation of individual transactions to simplify description
of non-state-machine transactions and help translation to concrete
implementations on Cardano. The structure of the state machine is enforced
on-chain through \emph{scripts} which run as part of the ledger's validation of
a transaction (see Section~\ref{sec:eutxo}). For each protocol transaction, the
specification defines the structure of the transaction and enumerates the
transaction constraints enforced by the scripts ($\cemTxCon$ in the CEM
formalism).

% TODO: Create example, maybe using the collectComTx, but with generic labels
% and point out that state input/outputs do represent a transition in the
% statemachine from s' to s' etc.
TODO{Add an example graph with a legend}
*/
