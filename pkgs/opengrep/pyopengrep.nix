{
  pkgs,
  opengrep,
}: let
  source = pkgs.fetchFromGitHub {
    owner = "spotdemo4";
    repo = "opengrep";
    rev = "b1dded4f189b06c404a197316d645d769531a392";
    hash = "sha256-F71YxtlIna470mdBc9Kb7nHaX6mjqejFnQxx3FSlQqQ=";
    fetchSubmodules = true;
  };
in
  with pkgs.python311Packages;
    buildPythonApplication {
      pname = "pyopengrep";
      inherit (opengrep) version;
      src = "${source}/cli";

      pyproject = true;
      build-system = [setuptools];

      pythonRelaxDeps = [
        "boltons"
        "defusedxml"
        "exceptiongroup"
        "glom"
        "rich"
        "tomli"
        "wcmatch"
      ];

      # coupling: anything added to the pysemgrep setup.py should be added here
      propagatedBuildInputs = [
        attrs
        boltons
        click
        click-option-group
        colorama
        defusedxml
        exceptiongroup
        glom
        jsonschema
        packaging
        peewee
        requests
        rich
        ruamel-yaml
        tomli
        tqdm
        typing-extensions
        urllib3
        wcmatch
        protobuf
        jaraco-text
      ];

      preFixup = ''
        makeWrapperArgs+=(--prefix PATH : ${opengrep}/bin)
      '';
    }
