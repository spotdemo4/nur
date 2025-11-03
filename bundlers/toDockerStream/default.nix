{
  drv,
  pkgs,
}:
pkgs.dockerTools.streamLayeredImage {
  name = "${drv.pname}";
  tag = "${drv.version}";
  created = "now";
  contents = [drv];
  config = {
    Cmd = [
      "${pkgs.lib.meta.getExe drv}"
    ];
  };
}
