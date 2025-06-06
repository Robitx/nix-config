{ config, lib, pkgs, ... }:

{
  options.desktop.utilities = {
    enable = lib.mkEnableOption "desktop utility applications";
    
    screenshots = lib.mkEnableOption "screenshot tools (grim, slurp)";
    clipboard = lib.mkEnableOption "clipboard manager (cliphist)";
    brightness = lib.mkEnableOption "brightness control (brightnessctl)";
    displays = lib.mkEnableOption "display configuration (wdisplays)";
    statusBar = lib.mkEnableOption "status bar (waybar)";
    wallpaper = lib.mkEnableOption "wallpaper manager (hyprpaper)";
    networkApplet = lib.mkEnableOption "network manager applet";
  };

  config = lib.mkIf config.desktop.utilities.enable {
    environment.systemPackages = with pkgs; lib.optionals config.desktop.utilities.screenshots [
      grim
      slurp
    ] ++ lib.optionals config.desktop.utilities.clipboard [
      cliphist
    ] ++ lib.optionals config.desktop.utilities.brightness [
      brightnessctl
    ] ++ lib.optionals config.desktop.utilities.displays [
      wdisplays
    ] ++ lib.optionals config.desktop.utilities.statusBar [
      waybar
    ] ++ lib.optionals config.desktop.utilities.wallpaper [
      hyprpaper
    ] ++ lib.optionals config.desktop.utilities.networkApplet [
      networkmanagerapplet
    ];
  };
}
