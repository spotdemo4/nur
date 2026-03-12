{
  rust,
  callPackage,
}:

rust.override {
  compile = callPackage ./compile.nix { };
}
