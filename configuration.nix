{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./modules
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Desktop environment
  desktop = {
    hyprland.enable = false;
    sway.enable = true;
    audio.enable = true;
    audio.lowLatency = true; # For audio production
    bluetooth.enable = true;
    fonts.enable = true;
    utilities = {
      enable = true;
      screenshots = true;
      clipboard = true;
      brightness = true;
      displays = true;
      statusBar = true;
      wallpaper = true;
      networkApplet = true;
    };
  };

  # Development environment
  development = {
    enable = true;
    languages = {
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
    tools = {
      vscode.enable = true;
      git = {
        enable = true;
        enableGitHub = true;
        enableAdvancedTools = true;
      };
      kubernetes = {
        enable = true;
        enableHelm = true;
      };
      opencode = {
        enable = true;
      };
      antigravity-fhs.enable = true;
    };
    containers = {
      enable = true;
      enableDocker = true;
      enableDevContainers = true;
      enableCI = true;
    };
  };

  # Applications
  applications = {
    enable = true;
    browsers = {
      enable = true;
      chrome = true;
      vivaldi = true;
      defaultBrowser = "chrome";
    };
    communication = {
      enable = true;
      thunderbird = true;
      signal = true;
    };
    media = {
      enable = true;
      graphics.gimp = true;
      audio = {
        audacity = true;
        enableLameSupport = true;
      };
      video.vlc = true;
    };
    productivity = {
      enable = true;
      office = {
        libreoffice = true;
        spellcheck = true;
        languageTools = true;
      };
      notes.obsidian = true;
      downloads.qbittorrent = true;
      cad.prusaSlicer = true;
      cad.superSlicer = true;
      cad.openscad = true;
      archives = true;
    };
    utilities = {
      enable = true;
      system = {
        diskUsage = true;
        partitioning = true;
        fileComparison = true;
        calendar = true;
        systemInfo = true;
        rpiImager = true;
      };
      network = {
        basic = true;
        vpn = true;
      };
      packageManager = true;
    };
  };

  # Services
  services = {
    enable = true;
    system.optimizeSystemd = true;
  };
}
