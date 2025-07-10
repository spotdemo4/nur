{
  pkgs,
  opam-nix,
}: let
  opengrep = import ./opengrep.nix {inherit pkgs opam-nix;};
in
  import ./pyopengrep.nix {inherit pkgs opengrep;}
