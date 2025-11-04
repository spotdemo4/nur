{
  default = final: prev: let
    nur = import ../. {
      pkgs = prev;
    };
  in {
    trev = nur;
  };

  packages = final: prev: let
    pkgs = import ../packages {
      pkgs = prev;
    };
  in
    pkgs;

  libs = final: prev: let
    libs = import ../libs {
      pkgs = prev;
    };
  in {
    lib = libs;
  };
}
