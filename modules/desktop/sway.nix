{ config, lib, pkgs, ... }:

{
  options.desktop.sway = {
    enable = lib.mkEnableOption "Sway window manager";

    enableXWayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable XWayland support";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages for Sway desktop environment";
    };
  };

  config = lib.mkIf config.desktop.sway.enable {

    security.polkit.enable = true;

    services.gnome.gnome-keyring.enable = true;

    # Sway window manager
    programs.xwayland.enable = true;
    programs.sway = {
      enable = true;
      # wrapperFeatures.gtk = true;
      # xwayland.enable = true;
      extraOptions = [ "--unsupported-gpu" ];
      extraSessionCommands = ''
      '';
      extraPackages = with pkgs; [
        swaylock
        swayidle
        foot # Default terminal for Sway
        dmenu # Default menu for Sway
        wmenu # Wayland-native dmenu replacement
        i3status # Status bar from i3
        sway-contrib.grimshot # Enhanced screenshot tool
      ];
    };

    programs.waybar.enable = true;
    services.dbus.enable = true;

    # XDG Desktop Portal for screen sharing, etc.
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr.enable = true;
      # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    # Hardware graphics acceleration
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Essential Wayland/Sway packages
    environment.systemPackages = with pkgs; [
      # Notifications
      mako
      libnotify

      # Application launcher (Sway-compatible)
      rofi
      wofi

      # Wallpaper
      swaybg

      # xwayland # XWayland support

      # # GTK settings
      # glib # for gsettings
      # pkgs.adwaita-icon-theme
      # gtk-engine-murrine
      # gtk_engines
      # gsettings-desktop-schemas

      # Screenshots
      grim
      slurp

      # Clipboard
      wl-clipboard
      wl-clip-persist

      # Display configuration
      wdisplays
      kanshi # Auto display configuration

      # Status bar (waybar works with both Hyprland and Sway)
      waybar

      # Brightness control
      brightnessctl

      # Color temperature
      wlsunset

      # Audio control
      pavucontrol

      # Network applet
      networkmanagerapplet

      # File manager (same as Hyprland config)
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin

      # gnome-keyring
      # xdg-utils
      # xdg-desktop-portal-wlr

    ] ++ config.desktop.sway.extraPackages;

    # Thunar file manager configuration (same as Hyprland)
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

    # Sway-specific environment variables
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # electron & chromium wayland
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
      # GTK_USE_PORTAL = "1";
    };
  };
}
