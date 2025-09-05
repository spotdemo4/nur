{
  description = "Trev's NUR";

  nixConfig = {
    extra-substituters = [
      "https://trevnur.cachix.org"
    ];
    extra-trusted-public-keys = [
      "trevnur.cachix.org-1:hBd15IdszwT52aOxdKs5vNTbq36emvEeGqpb25Bkq6o="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nur,
  }: let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  in rec {
    devShells = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [nur.overlays.default];
        };
        trev = pkgs.nur.repos.trev;
        update = pkgs.callPackage ./update.nix {};
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            update
            alejandra
            flake-checker
            prettier
            action-validator
            trev.renovate
          ];
          shellHook = trev.shellhook.ref;
        };
      }
    );

    checks = forAllSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [nur.overlays.default];
      };
      trev = pkgs.nur.repos.trev;
    in
      trev.lib.mkChecks {
        lint = {
          src = ./.;
          deps = with pkgs; [
            alejandra
            prettier
            action-validator
            trev.renovate
          ];
          script = ''
            alejandra -c .
            prettier --check .
            action-validator .github/**/*.yaml
            renovate-config-validator .github/renovate*.json
          '';
        };
      }
      // packages."${system}"
      // {
        shell = devShells."${system}".default;
      });

    legacyPackages = forAllSystems (
      system:
        import ./default.nix {
          inherit system;
          pkgs = nixpkgs.legacyPackages."${system}";
        }
    );

    packages = forAllSystems (
      system:
        nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system}
    );
  };
}
