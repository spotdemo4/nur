{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> {inherit system;},
}: rec {
  lib = import ./lib {inherit pkgs;}; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  # libraries
  opam-nix = import ./libs/opam-nix/src/opam.nix {
    inherit pkgs;
  };

  # packages
  bobgen = pkgs.callPackage ./pkgs/bobgen {};
  protoc-gen-connect-openapi = pkgs.callPackage ./pkgs/protoc-gen-connect-openapi {};
  opengrep = pkgs.callPackage ./pkgs/opengrep {inherit pkgs opam-nix;};
}
