{ config, lib, pkgs, ... }:

{
  imports = [
    ./browsers.nix
    ./communication.nix
    ./media.nix
    ./productivity.nix
    ./utilities.nix
  ];

  options.applications = {
    enable = lib.mkEnableOption "user applications";
  };

  config = lib.mkIf config.applications.enable {
    # When applications are enabled, we might want some defaults
    # but keep each category independently configurable
  };
}
