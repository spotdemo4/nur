{
  default =
    _: pkgs:
    let
      nur = import ../. {
        system = pkgs.stdenv.hostPlatform.system;
        pkgs = pkgs;
      };
    in
    {
      trev = nur;
    };

  packages =
    _: pkgs:
    let
      packages = import ../packages {
        system = pkgs.stdenv.hostPlatform.system;
        pkgs = pkgs;
      };
    in
    pkgs // packages;

  libs =
    _: pkgs:
    let
      libs = import ../libs {
        system = pkgs.stdenv.hostPlatform.system;
        pkgs = pkgs;
      };
    in
    {
      lib = pkgs.lib // libs;
    };

  images =
    _: pkgs:
    let
      images = import ../images {
        system = pkgs.stdenv.hostPlatform.system;
        pkgs = pkgs;
      };
    in
    {
      image = images;
    };

  inherit (import ./python.nix)
    python311Packages
    python312Packages
    python313Packages
    python314Packages
    python315Packages
    ;
}
