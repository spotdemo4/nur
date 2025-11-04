{
  default = final: prev: let
    nur = import ../. {
      pkgs = prev;
    };
  in {
    trev = nur;
  };

  packages = final: prev: let
    nur = import ../packages {
      pkgs = prev;
    };
  in {
    trev = nur;
  };
}
