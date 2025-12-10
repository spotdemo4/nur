{
  default =
    _: prev:
    let
      nur = import ../. {
        pkgs = prev;
      };
    in
    {
      trev = nur;
    };

  packages =
    _: prev:
    let
      pkgs = import ../packages {
        pkgs = prev;
      };
    in
    prev // pkgs;

  libs =
    _: prev:
    let
      libs = import ../libs {
        pkgs = prev;
      };
    in
    {
      lib = prev.lib // libs;
    };

  images =
    _: prev:
    let
      images = import ../images {
        pkgs = prev;
      };
    in
    {
      image = images;
    };
}
