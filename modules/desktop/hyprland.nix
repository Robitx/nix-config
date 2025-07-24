{ config, lib, pkgs, inputs, ... }:

let
  inherit (inputs.hyprland.packages.${pkgs.system}) hyprland xdg-desktop-portal-hyprland;
in

{
  options.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland window manager";

    enableXWayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable XWayland support";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages for Hyprland desktop environment";
    };
  };

  config = lib.mkIf config.desktop.hyprland.enable {
    # Hyprland window manager
    programs.hyprland = {
      enable = true;
      xwayland.enable = config.desktop.hyprland.enableXWayland;
      package = hyprland;
      portalPackage = xdg-desktop-portal-hyprland;
    };

    # XDG Desktop Portal
    xdg.portal = {
      enable = true;
      extraPortals = [ xdg-desktop-portal-hyprland ];
    };

    # Hardware graphics acceleration
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Essential Wayland/Hyprland packages
    environment.systemPackages = with pkgs; [
      # Notifications and rofi
      mako
      libnotify
      rofi-wayland

      wlsunset

      # Clipboard
      wl-clipboard
      wl-clip-persist

      # File manager
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin

    ] ++ config.desktop.hyprland.extraPackages;

    # Thunar file manager configuration
    programs.xfconf.enable = true;
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };

    # File system services for Thunar
    services.gvfs.enable = true;
    services.tumbler.enable = true;

    # Allow users to mount filesystems
    programs.fuse.userAllowOther = true;
  };
}
