{ config, lib, pkgs, inputs, ... }:

let
  inherit (inputs.hyprland.packages.${pkgs.system}) hyprland xdg-desktop-portal-hyprland;
in

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = hyprland;
    portalPackage = xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ xdg-desktop-portal-hyprland ];
  };


  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    mako
    libnotify
    rofi-wayland
    wl-clipboard
  ];

  security = {
    rtkit.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

  };


  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;

  programs.xfconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.fuse.userAllowOther = true;
}
