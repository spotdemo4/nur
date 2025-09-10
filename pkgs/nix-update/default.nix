{callPackage, ...}: rec {
  unstable = callPackage ./unstable.nix {};
  update-script = callPackage ./update-script.nix {
    nix-update = unstable;
  };
}
