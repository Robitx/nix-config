{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./modules
  ];

  # Desktop environment
  desktop = {
    hyprland.enable = true;
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
      };
      network = {
        basic = true;
        vpn = true;
      };
      packageManager = true;
    };
  };

  # Shell configuration
  shell = {
    enable = true;
    defaultShell = "zsh";

    # Zsh configuration
    zsh = {
      enable = true;
      enableSyntaxHighlighting = true;
      enableAutosuggestions = false;
      enableTmuxAutoStart = true;
      nixosAliases = true;
      customAliases = {
        lah = "ls -lah";
        ll = "ls -l";
        update = "export NIXPKGS_ALLOW_BROKEN=1; sudo nixos-rebuild boot --impure --flake '/persist/nix-config#'$(hostname) --max-jobs 2 --cores 4";
        update-test = "export NIXPKGS_ALLOW_BROKEN=1; sudo nixos-rebuild test --impure --flake '/persist/nix-config#'$(hostname) --max-jobs 2 --cores 4";
        update-full = "sudo nix flake update; update";
        update-safe = "sudo nix flake update nixpkgs home-manager; update";
        history = "history 0";
        history-stat = "history | awk '{print \\$2}' | sort | uniq -c | sort -n -r | head";
      };
    };

    # Tmux configuration
    tmux = {
      enable = true;
      enableMouse = true;
      enableVimMode = true;
      prefix = "C-a";
      statusPosition = "top";
      enablePluginManager = true;
    };

    # Terminal emulator
    terminal = {
      enable = true;
      emulator = "kitty";
    };
  };

  # Services
  services = {
    enable = true;
    system.optimizeSystemd = true;
  };
}
