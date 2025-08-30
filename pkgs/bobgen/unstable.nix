{
  bobgen,
  fetchFromGitHub,
  nix-update-script,
  lib,
  ...
}:
bobgen.overrideAttrs
(final: prev: {
  version = "0.40.2-unstable-2025-08-28";

  src = fetchFromGitHub {
    owner = "stephenafamo";
    repo = "bob";
    rev = "a864228459c7680626d7788bc27f45ea94256669";
    hash = "sha256-tPkTYQOihPJWuhRSTvT22EtKqRaPztZBGTcNaA1YLM8=";
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
