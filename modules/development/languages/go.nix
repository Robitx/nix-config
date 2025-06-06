{ config, lib, pkgs, ... }:

{
  options.development.languages.go = {
    enable = lib.mkEnableOption "Go development environment";

    version = lib.mkOption {
      type = lib.types.str;
      default = "latest";
      description = "Go version to install";
    };

    enablePrivateModules = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable support for private Go modules";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional Go-related packages";
    };
  };

  config = lib.mkIf config.development.languages.go.enable {
    environment.systemPackages = with pkgs; [
      # Go toolchain
      go
      
      # Language server and tools
      gopls
      
      # Formatting and linting
      golines
      revive
      golangci-lint
      
      # Debugging
      delve
      
    ] ++ config.development.languages.go.extraPackages;

    environment.variables = {
      # Go environment
      GOPATH = "/home/tibor/go"; # You might want to make this configurable
      GO111MODULE = "on";
    } // lib.optionalAttrs config.development.languages.go.enablePrivateModules {
      GOPRIVATE = "gitlab.seznam.net";
    };

    # Ensure Go workspace directories exist for users
    systemd.tmpfiles.rules = [
      "d /home/tibor/go 0755 tibor users -"
      "d /home/tibor/go/bin 0755 tibor users -"
      "d /home/tibor/go/src 0755 tibor users -"
      "d /home/tibor/go/pkg 0755 tibor users -"
    ];
  };
}
