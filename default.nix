{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> {inherit system;},
}: {
  lib = import ./lib {inherit pkgs;}; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  bobgen = pkgs.callPackage ./pkgs/bobgen {};
  protoc-gen-connect-openapi = pkgs.callPackage ./pkgs/protoc-gen-connect-openapi {};
  opengrep = pkgs.callPackage ./pkgs/opengrep {inherit system pkgs;};
}
