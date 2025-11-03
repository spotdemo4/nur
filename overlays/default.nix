{
  default = final: prev: let
    nur = import ../. {
      pkgs = prev;
    };
  in {
    trev = nur;
  };
}
