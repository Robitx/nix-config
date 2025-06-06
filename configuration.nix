{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./modules/system/boot.nix
      ./modules/system/base.nix
      ./modules/system/persistence.nix
      ./modules/overlays/default.nix
      ./modules/desktop/hyprland.nix
      ./modules/desktop/monitors.nix
      ./modules/users/tibor.nix
      ./modules/services/default.nix
      # Include the results of the hardware scan.
    ];
}

