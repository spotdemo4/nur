{
  pkgs,
  drv,
  target,
}:
drv.overrideAttrs (
  finalAttrs: previousAttrs:
  let
    binName = if target == "bun-windows-x64" then "${previousAttrs.pname}.exe" else previousAttrs.pname;
  in
  {
    pname = "${previousAttrs.pname}-${target}";

    doCheck = false;

    nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
      pkgs.bun
      pkgs.upx
    ];

    # compile to binary with bun
    installPhase = ''
      runHook preInstall

       mkdir -p ''${out}/bin
       bun build --compile --minify --sourcemap \
        --target="${target}" \
        --outfile "''${out}/bin/${binName}" build/index.js

       runHook postInstall
    '';

    # compress binary
    postInstall = ''
      FILE=$(find "''${out}" -type f -print -quit)
      TMP_FILE="''${TMPDIR:-/tmp}/bin"

      mv "''${FILE}" "''${TMP_FILE}"
      rm -rf "''${out}"
      upx --best --lzma "''${TMP_FILE}" || true

      cat "''${TMP_FILE}" > "''${out}"
      chmod +x "''${out}"
    '';

    meta.mainProgram = binName;
  }
)
