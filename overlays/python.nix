{
  python311Packages =
    _: pkgs:
    let
      packages = import ../packages {
        system = pkgs.stdenv.hostPlatform.system;
        pkgs = pkgs;
      };
      python311Packages = pkgs.lib.attrsets.mapAttrs (_: v: v.python311) (
        pkgs.lib.filterAttrs (_: pkg: builtins.hasAttr "python311" pkg) packages
      );
    in
    pkgs.python311Packages // python311Packages;

  python312Packages =
    _: pkgs:
    let
      packages = import ../packages {
        system = pkgs.stdenv.hostPlatform.system;
        pkgs = pkgs;
      };
      python312Packages = pkgs.lib.attrsets.mapAttrs (_: v: v.python312) (
        pkgs.lib.filterAttrs (_: pkg: builtins.hasAttr "python312" pkg) packages
      );
    in
    pkgs.python312Packages // python312Packages;

  python313Packages =
    _: pkgs:
    let
      packages = import ../packages {
        system = pkgs.stdenv.hostPlatform.system;
        pkgs = pkgs;
      };
      python313Packages = pkgs.lib.attrsets.mapAttrs (_: v: v.python313) (
        pkgs.lib.filterAttrs (_: pkg: builtins.hasAttr "python313" pkg) packages
      );
    in
    pkgs.python313Packages // python313Packages;

  python314Packages =
    _: pkgs:
    let
      packages = import ../packages {
        system = pkgs.stdenv.hostPlatform.system;
        pkgs = pkgs;
      };
      python314Packages = pkgs.lib.attrsets.mapAttrs (_: v: v.python314) (
        pkgs.lib.filterAttrs (_: pkg: builtins.hasAttr "python314" pkg) packages
      );
    in
    pkgs.python314Packages // python314Packages;

  python315Packages =
    _: pkgs:
    let
      packages = import ../packages {
        system = pkgs.stdenv.hostPlatform.system;
        pkgs = pkgs;
      };
      python315Packages = pkgs.lib.attrsets.mapAttrs (_: v: v.python315) (
        pkgs.lib.filterAttrs (_: pkg: builtins.hasAttr "python315" pkg) packages
      );
    in
    pkgs.python315Packages // python315Packages;
}
