{
  system,
}:
(builtins.getFlake "github:spotdemo4/nix-fix-hash/9d7e396cd940e50a7ff57d97e4fcc6eeab8b7b19" # v0.1.1
).packages."${system}".default
