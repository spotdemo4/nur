{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> {inherit system;},
}:
{
  toDockerStream = drv:
    import ./toDockerStream {
      inherit drv pkgs;
    };
}
// import ./toGo {
  inherit system pkgs;
}
