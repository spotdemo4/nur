{
  pkgs,
  drv,
  goos,
  goarch,
}:
drv.overrideAttrs (finalAttrs: previousAttrs: {
  pname = "${previousAttrs.pname}-${goos}-${goarch}";
  env =
    previousAttrs.env
    // {
      GOOS = goos;
      GOARCH = goarch;
    };

  doCheck = false;

  # normalize cross-compiled builds
  postBuild = ''
    dir=$GOPATH/bin/''${GOOS}_''${GOARCH}
    if [[ -n "$(shopt -s nullglob; echo $dir/*)" ]]; then
      mv $dir/* $dir/..
    fi
    if [[ -d $dir ]]; then
      rmdir $dir
    fi
  '';

  nativeBuildInputs =
    previousAttrs.nativeBuildInputs
    ++ [pkgs.upx];

  # compress binary
  postInstall = ''
    FILE=$(find "''${out}" -type f -print -quit)
    mv "''${FILE}" /tmp/bin
    rm -rf "''${out}"
    upx --best --lzma /tmp/bin
    cat /tmp/bin > "''${out}"
  '';

  meta =
    if builtins.hasAttr "meta" previousAttrs
    then
      if builtins.hasAttr "mainProgram" previousAttrs.meta && goos == "windows"
      then previousAttrs.meta // {mainProgram = "${previousAttrs.meta.mainProgram}.exe";}
      else previousAttrs.meta
    else {};
})
