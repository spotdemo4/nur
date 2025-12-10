{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; },
}:
{
  bobgen = pkgs.callPackage ./bobgen { };
  bumper = pkgs.callPackage ./bumper { inherit system; };
  ffmpeg-quality-metrics = pkgs.callPackage ./ffmpeg-quality-metrics { };
  nix-fix-hash = pkgs.callPackage ./nix-fix-hash { inherit system; };
  opengrep = pkgs.callPackage ./opengrep { };
  protoc-gen-connect-openapi = pkgs.callPackage ./protoc-gen-connect-openapi { };
  qsvenc = pkgs.callPackage ./qsvenc { };
  renovate = pkgs.callPackage ./renovate { };
  shellhook = pkgs.callPackage ./shellhook { };
}
