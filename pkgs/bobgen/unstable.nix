{
  bobgen,
  fetchFromGitHub,
  nix-update-script,
  lib,
  ...
}:
bobgen.overrideAttrs
(final: prev: {
  version = "0.40.2-unstable-2025-08-19";

  src = fetchFromGitHub {
    owner = "stephenafamo";
    repo = "bob";
    rev = "2ca61849c6db06703a82095ddb64e454921beb60";
    hash = "sha256-y6UZAn4evzWe91ChEzEvZQgsWHxcu5oAlRSPF8j3hZU=";
  };

  vendorHash = "sha256-3K5ByPBrZRsLcmp0JMNLCcLqQdQizTdxN1Q7B4xe9vc=";

  passthru = {
    updateScript = lib.concatStringsSep " " (nix-update-script {
      extraArgs = [
        "--commit"
        "--version=branch=main"
        "${final.pname}.unstable"
      ];
    });
  };

  meta =
    prev.meta
    // {
      description = "${prev.meta.description} - main branch";
      changelog = "https://github.com/stephenafamo/bob/commits/${final.src.rev}/";
    };
})
