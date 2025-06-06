{ config, lib, pkgs, secrets, osConfig, inputs, ... }:

let
  inherit (inputs.hyprland.packages.${pkgs.system}) hyprland xdg-desktop-portal-hyprland;
in

{
  home.stateVersion = "25.05";

  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.username = "tibor";
  home.homeDirectory = "/home/tibor";

  # Persistence configuration
  home.persistence."/persist/home/tibor" = {
    removePrefixDirectory = false;
    directories = [
      ".cache"
      ".config/Signal"
      ".config/dconf"
      ".config/github-copilot"
      ".config/google-chrome"
      ".config/hypr"
      ".config/libreoffice"
      ".config/qBittorrent"
      ".config/PrusaSlicer"
      ".config/syncthing"
      ".config/waybar"
      ".config/obsidian"
      ".config/matterhorn"
      ".gnupg"
      ".local/share/Steam"
      ".local/share/direnv"
      ".local/share/keyrings"
      ".local/share/nvim"
      ".local/share/qBittorrent"
      ".local/state/nvim"
      ".local/state/syncthing"
      ".mozilla"
      ".nixops"
      ".ollama"
      ".ssh"
      ".thunderbird"
      ".tmux/plugins"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
      "VirtualBox VMs"
      "quickemu"
    ];
    files = [
      ".screenrc"
      ".bash_history"
    ];
    allowOther = true;
  };

  # Theme and cursor configuration
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    font = {
      name = "Sans";
      size = 11;
    };
  };

  # Personal services
  services.syncthing.enable = true;
  services.ssh-agent.enable = true;
  services.wlsunset = {
    enable = true;
    latitude = "50.0755";
    longitude = "14.4378";
    gamma = "0.8";
    temperature = {
      day = 4800;
      night = 3600;
    };
  };

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Shell configuration (if not moved to system modules)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  # ZSH configuration (could be moved to shell modules)
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestion = {
      enable = false;
    };
    syntaxHighlighting = {
      enable = true;
    };
    shellAliases = {
      lah = "ls -lah";
      update = "export NIXPKGS_ALLOW_BROKEN=1; sudo nixos-rebuild boot --impure --flake '/persist/nix-config#'$(hostname) --max-jobs 2 --cores 4";
      update-test = "export NIXPKGS_ALLOW_BROKEN=1; sudo nixos-rebuild test --impure --flake '/persist/nix-config#'$(hostname) --max-jobs 2 --cores 4";
      update-full = "sudo nix flake update; update";
      update-safe = "sudo nix flake update nixpkgs home-manager; update";
      history = "history 0";
      history-stat = "history | awk '{print \\$2}' | sort | uniq -c | sort -n -r | head";
    };

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        if [ -z "$TMUX" ] && [ "$XDG_SESSION_TYPE" != "tty" ]
        then
          tmux attach -t TMUX || tmux new -s TMUX;
          return;
        fi
      '')
      (lib.mkOrder 550 ''
        ${builtins.readFile ./dotfiles/.zshrcInitExtraBeforeCompInit}
      '')
      ''
        ${builtins.readFile ./dotfiles/.zshrcInitExtra}
      ''
    ];

    completionInit = ''
      autoload -Uz compinit; compinit -C
      (autoload -Uz compinit; compinit &)
    '';

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      ignoreDups = false;
      ignoreSpace = true;
      path = "/persist/sync/.zsh_history";
      share = true;
      size = 16777216;
      save = 8388608;
    };

    localVariables = {
      RANDOM_VARIABLE_TEST = "dummy";
    };
  };

  # Editor configuration
  programs.neovim = {
    package = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.neovim-unwrapped;
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Hyprland configuration (window manager specific)
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland;
    extraConfig = ''
      ${osConfig.desktop.monitors.hyprlandConfig}
      ${builtins.readFile ./dotfiles/.config/hypr/hyprland.conf}
    '';
  };

  # Dotfiles and configuration files
  home.file.".tmux.conf".source = ./dotfiles/.tmux.conf;
  home.file.".tmux/plugins/tpm".source = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "v3.1.0";
    hash = "sha256-CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
  };

  home.file.".config/git/config".source = ./dotfiles/.config/git/config;
  home.file.".config/git/config.szn".source = ./dotfiles/.config/git/config.szn;
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink /persist/nvim;
  home.file.".config/nvim".recursive = true;
  home.file.".config/kitty/kitty.conf".source = ./dotfiles/.config/kitty/kitty.conf;
  home.file.".ssh/config".source = config.lib.file.mkOutOfStoreSymlink /persist/nix-config/dotfiles/.ssh/config;
  home.file.".config/hypr/hyprpaper.conf".source = ./dotfiles/.config/hypr/hyprpaper.conf;
  home.file.".config/waybar/config".source = ./dotfiles/.config/waybar/config;
  home.file.".config/waybar/style.css".source = ./dotfiles/.config/waybar/style.css;

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
