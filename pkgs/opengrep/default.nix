{
  system,
  pkgs,
}: let
  opengrep = import ./opengrep.nix {inherit system pkgs;};
in
  import ./pyopengrep.nix {inherit pkgs opengrep;}
