{
  bobgen,
  fetchFromGitHub,
  nix-update-script,
  lib,
  ...
}:
bobgen.overrideAttrs
(final: prev: {
  version = "0.40.0-unstable-2025-08-13";

  src = fetchFromGitHub {
    owner = "stephenafamo";
    repo = "bob";
    rev = "31f42799a21ddcf34ded9722751e213988c758bc";
    hash = "sha256-jR2XGgzuZdpU91t36cdA78vkw4lqjouvWfFRw8M/2Mw=";
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
