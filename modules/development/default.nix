{ config, lib, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./languages
    ./tools
    ./containers.nix
  ];

  options.development = {
    enable = lib.mkEnableOption "development environment";
  };

  config = lib.mkIf config.development.enable {
    # Always enable core development tools when development is enabled
    development.base.enable = true;
  };
}
