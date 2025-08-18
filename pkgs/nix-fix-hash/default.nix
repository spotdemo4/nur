{
  pkgs,
  fetchFromGitHub,
  writeShellApplication,
}: let
  source = fetchFromGitHub {
    owner = "spotdemo4";
    repo = "nix-fix-hash";
    tag = "v0.0.1";
    hash = "sha256-rQnjZ9bSU2qj9cJmwtHdMeok2BuRpo0eVCTXZ3TXJf0=";
    fetchSubmodules = true;
  };
in
  writeShellApplication {
    name = "nix-fix-hash";

    runtimeInputs = with pkgs; [
      nix
      ncurses
    ];

    text = builtins.readFile (source + "/nix-fix-hash.sh");

    meta = {
      description = "Nix hash fixer";
      mainProgram = "nix-fix-hash";
      homepage = "https://github.com/spotdemo4/nix-fix-hash";
      platforms = pkgs.lib.platforms.all;
    };
  }
