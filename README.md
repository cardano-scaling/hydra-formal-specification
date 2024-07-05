# hydra-formal-specification

Agda specification for the hydra-protocol.

## Devshell For Type Checking

To enter the devShell 

```
nix develop .#hydra-protocol-typecheck
cd hydra-protocol
agda Hydra/Protocol/Main.lagda
```

## Building a PDF

```
nix build
```
