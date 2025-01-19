= Protocol Setup
<setup>

In order to create a head-protocol instance, an initiator invites a set of
participants (the initiator being one of them) to join by announcing to them the
protocol parameters.

- For on-chain transaction authentication (Cardano) purposes, each party
     $\P_i$ generates a corresponding key pair $(sans("msVK")_i,sans("msSK")_i)$
	      and sends their verification key $(sans("msVK")_i$ to all other parties. In
	      the case of Cardano, these are Ed25519 keys.

- For off-chain signing (Hydra) purposes, a very basic multisignature scheme (MS, as defined in Section~\ref{sec:multisig}) based on EdDSA using Ed25519 keys is used:
  - $sans("msKeyGen")$ is Ed25519 key generation (requires no parameters)
  - $sans("msSign")$ creates an EdDSA signature
  - $sans("msCombVK")$ is concatenation of verification keys into an ordered list
  - $sans("msComb")$ is concatenation of signatures into an ordered list
  - $sans("msVfy")$ verifies the "aggregate" signature by verifying each individual EdDSA signature under the corresponding Ed25519 verification key

  To help distinguish on- and off-chain key sets, Cardano verification
  keys are written $sans("cardanoKey")$, while Hydra verification keys are
  indicated as $sans("hydraKey")$ for the remainder of this document.
        
  % TODO: Move this and previous bullet point into the preliminary section, or all multi-sig definition here?

  - Each party $\P_i$ generates a hydra key pair and sends their hydra verification key to all other parties.

  - Each party $\P_i$ computes the aggregate key from the received verification keys, stores the aggregate key,
	      their signing key as well as the number of participants $\nop$.

  - Each party establishes pairwise communication channels to all other parties. That is, every network message received from a specific party is checked for (channel) authentication. It is the implementer’s duty to find a suitable authentication process for the communication channels.

  - All parties agree on a contestation period $sans("cPer")$.

If any of the above fails (or the party does not agree to join the head in the
first place), the party aborts the initiation protocol and ignores any further
action. Finally, at least one of the participants posts the \mtxInit{} transaction
onchain as described next in @on-chain.
