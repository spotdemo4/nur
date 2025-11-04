{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> {inherit system;},
}: {
  toDockerStream = drv:
    import ./toDockerStream {
      inherit drv pkgs;
    };

  goToLinuxArm = drv:
    import ./goTo/go.nix {
      inherit drv;
      goos = "linux";
      goarch = "arm";
    };
}
