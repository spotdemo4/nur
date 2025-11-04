{pkgs}: let
  GOOS = [
    "Aix"
    "Android"
    "Darwin"
    "Dragonfly"
    "Freebsd"
    "Hurd"
    "Illumos"
    "Ios"
    "Js"
    "Linux"
    "Nacl"
    "Netbsd"
    "Openbsd"
    "Plan9"
    "Solaris"
    "Windows"
    "Zos"
  ];

  GOARCH = [
    "386"
    "Amd64"
    "Amd64p32"
    "Arm"
    "Arm64"
    "Arm64be"
    "Armbe"
    "Loong64"
    "Mips"
    "Mips64"
    "Mips64le"
    "Mips64p32"
    "Mips64p32le"
    "Mipsle"
    "Ppc"
    "Ppc64"
    "Ppc64le"
    "Riscv"
    "Riscv64"
    "S390"
    "S390x"
    "Sparc"
    "Sparc64"
    "Wasm"
  ];
in
  builtins.listToAttrs (
    pkgs.lib.attrsets.mapCartesianProduct (
      {
        goos,
        goarch,
      }:
        pkgs.lib.attrsets.nameValuePair "goTo${goos}${goarch}"
        (
          drv:
            import ./. {
              inherit drv goos goarch;
            }
        )
    )
    {
      goos = GOOS;
      goarch = GOARCH;
    }
  )
