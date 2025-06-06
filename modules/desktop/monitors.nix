{ config, lib, pkgs, ... }:

{
  options.desktop.monitors = {
    hyprlandConfig = lib.mkOption {
      type = lib.types.str;
      default = "monitor=,highres,auto,1";
      description = "Hyprland monitor configuration";
    };
  };

  config = {
    # This module just provides the option, actual config is set in hardware modules
  };
}
