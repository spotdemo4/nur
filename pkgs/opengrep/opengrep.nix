{
  system,
  pkgs,
}: let
  opan-nix = builtins.fetchTarball {
    url = "https://github.com/tweag/opam-nix/archive/main.tar.gz";
    sha256 = "sha256:1ijryni1fkh2iq0dy0j0s960wbw7c94kjxa0iivh16afccakb2gd";
  };
  opan-repository = pkgs.fetchFromGitHub {
    owner = "ocaml";
    repo = "opam-repository";
    rev = "0802514b70b2024a6cd3a5b69a639c1a4b68ecdc";
    hash = "sha256-fXac7oaGtDqoydWIZ/OlCi53XhXlBVdBchMsrqLJv4g=";
  };
  source = pkgs.fetchFromGitHub {
    owner = "spotdemo4";
    repo = "opengrep";
    rev = "b1dded4f189b06c404a197316d645d769531a392";
    hash = "sha256-F71YxtlIna470mdBc9Kb7nHaX6mjqejFnQxx3FSlQqQ=";
    fetchSubmodules = true;
  };

  on = (import opan-nix).lib."${system}";

  query = {
    # You can force versions of certain packages here
    ocaml-base-compiler = "5.3.0";
    mirage-runtime = "4.9.0";

    # coupling: if you add one thing here, need to update also the buildInputs overlay below
    git-unix = "*";
    junit_alcotest = "*";
    notty = "*";
    tsort = "*";
    tyxml = "*";
  };

  scope =
    on.buildOpamProject' {
      pkgs = pkgs;
      repos = [opan-repository];
    }
    source
    query;

  overlay = final: prev: {
    conf-pkg-config = prev.conf-pkg-config.overrideAttrs (prev: {
      # We need to add the pkg-config path to the PATH so that dune can find it
      nativeBuildInputs = prev.nativeBuildInputs ++ [pkgs.pkg-config];
    });
    semgrep = prev.semgrep.overrideAttrs (prev: {
      # Prevent the ocaml dependencies from leaking into dependent environments
      doNixSupport = false;
      buildInputs =
        prev.buildInputs
        ++ [
          final.git-unix
          final.junit_alcotest
          final.notty
          final.tsort
          final.tyxml
        ];
    });
  };

  scope' = scope.overrideScope overlay;

  # Package with all opam deps but nothing else
  baseOpamPackage = scope'.semgrep;
in
  baseOpamPackage.overrideAttrs (prev: {
    pname = "opengrep";
    env = {
      SEMGREP_NIX_BUILD = "1";
    };

    buildInputs =
      prev.buildInputs
      ++ (with pkgs; [
        pcre2
        tree-sitter
      ]);
    buildPhase = ''
      make core
    '';

    nativeCheckInputs = with pkgs; [cacert git];
    # git init is needed so tests work successfully since many rely on git root existing
    checkPhase = ''
      git init
      make test
    '';

    # Copy opengrep binaries
    installPhase = ''
      mkdir -p $out/bin
      cp _build/install/default/bin/* $out/bin
    '';
  })
