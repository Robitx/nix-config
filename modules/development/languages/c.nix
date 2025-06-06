{ config, lib, pkgs, ... }:

{
  options.development.languages.c = {
    enable = lib.mkEnableOption "C/C++ development environment";

    compiler = lib.mkOption {
      type = lib.types.enum [ "gcc" "clang" "both" ];
      default = "clang";
      description = "C/C++ compiler to install";
    };

    enableDebugTools = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include debugging tools (gdb, valgrind, etc.)";
    };

    enableStandardLibraries = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include common C/C++ libraries";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional C/C++ development packages";
    };
  };

  config = lib.mkIf config.development.languages.c.enable {
    environment.systemPackages = with pkgs; [
      # Build tools
      gnumake
      cmake
      pkg-config
      autoconf
      automake
      libtool
      
    ] ++ lib.optionals (config.development.languages.c.compiler == "gcc" || config.development.languages.c.compiler == "both") [
      gcc
      
    ] ++ lib.optionals (config.development.languages.c.compiler == "clang" || config.development.languages.c.compiler == "both") [
      clang_18
      clang-tools
      libgcc
      
    ] ++ lib.optionals config.development.languages.c.enableDebugTools [
      gdb
      valgrind
      strace
      ltrace
      
    ] ++ lib.optionals config.development.languages.c.enableStandardLibraries [
      # Common libraries
      openssl
      zlib
      curl
      sqlite
      
    ] ++ config.development.languages.c.extraPackages;

    # C/C++ development environment variables
    environment.variables = {
      # Common C/C++ flags for development
      CFLAGS = lib.mkDefault "-O2 -g";
      CXXFLAGS = lib.mkDefault "-O2 -g";
    };

    # Enable core dumps for debugging
    systemd.coredump.enable = lib.mkDefault config.development.languages.c.enableDebugTools;
  };
}
