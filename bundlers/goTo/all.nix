{pkgs}: let
  GOOS = [
    "aix"
    "android"
    "darwin"
    "dragonfly"
    "freebsd"
    "hurd"
    "illumos"
    "ios"
    "js"
    "linux"
    "nacl"
    "netbsd"
    "openbsd"
    "plan9"
    "solaris"
    "windows"
    "zos"
  ];

  GOARCH = [
    "386"
    "amd64"
    "amd64p32"
    "arm"
    "arm64"
    "arm64be"
    "armbe"
    "loong64"
    "mips"
    "mips64"
    "mips64le"
    "mips64p32"
    "mips64p32le"
    "mipsle"
    "ppc"
    "ppc64"
    "ppc64le"
    "riscv"
    "riscv64"
    "s390"
    "s390x"
    "sparc"
    "sparc64"
    "wasm"
  ];
in
  builtins.listToAttrs (
    pkgs.lib.attrsets.mapCartesianProduct (
      {
        goos,
        goarch,
      }: let
        capGoos = pkgs.lib.strings.toUpper (pkgs.lib.strings.substring 0 1 goos) + pkgs.lib.strings.substring 1 (pkgs.lib.strings.length goos - 1) goos;
        capGoarch = pkgs.lib.strings.toUpper (pkgs.lib.strings.substring 0 1 goarch) + pkgs.lib.strings.substring 1 (pkgs.lib.strings.length goarch - 1) goarch;
      in
        pkgs.lib.attrsets.nameValuePair "goTo${capGoos}${capGoarch}"
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
