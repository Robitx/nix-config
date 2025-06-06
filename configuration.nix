{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./modules/system/boot.nix
      ./modules/system/base.nix
      ./modules/system/persistence.nix
      ./modules/overlays/default.nix
      ./modules/desktop/hyprland.nix
      ./modules/desktop/audio.nix
      ./modules/desktop/bluetooth.nix
      ./modules/desktop/monitors.nix
      ./modules/desktop/fonts.nix
      ./modules/development/default.nix
      ./modules/users/tibor.nix
      ./modules/services/default.nix
      # Include the results of the hardware scan.
    ];

  # Enable desktop modules
  desktop.hyprland.enable = true;
  desktop.audio.enable = true;
  desktop.bluetooth.enable = true;
  desktop.fonts.enable = true;

  # Optional: customize settings
  desktop.audio.lowLatency = true; # For audio production
  # desktop.bluetooth.powerOnBoot = false; # If you want manual control

  # Development environment - just enable what you need
  development.enable = true;

  # Languages
  development.languages = {
    go.enable = true;
    rust.enable = true;
    python = {
      enable = true;
      enableDataScience = true;
      enableWeb = true;
    };
    javascript = {
      enable = true;
      enableTypeScript = true;
      nodeVersion = "nodejs_24";
    };
    lua = {
      enable = true;
      enableNeovimSupport = true;
    };
    c = {
      enable = true;
      compiler = "clang";
      enableDebugTools = true;
    };
  };

  # Development tools
  development.tools = {
    vscode.enable = true;
    git = {
      enable = true;
      enableGitHub = true;
      enableAdvancedTools = true;
    };
    kubernetes = {
      enable = true;
      enableHelm = true;
      enableLocalCluster = false;
    };
  };

  # Container development
  development.containers = {
    enable = true;
    enableDocker = true;
    enableDevContainers = true;
    enableCI = true;
  };
}
