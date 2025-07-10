{
  description = "Trev's NUR repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nur,
    ...
  }: let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  in {
    devShells = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            nur.legacyPackages."${system}".repos.trev.overlays.renovate
          ];
        };
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            git
            nix-update
            alejandra
            renovate
          ];
        };
      }
    );

    packages = forAllSystems (
      system:
        import ./default.nix {
          inherit system;
          pkgs = nixpkgs.legacyPackages."${system}";
        }
    );
  };
}
