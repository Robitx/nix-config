{ config, lib, pkgs, secrets, osConfig, inputs, ... }:

let
  inherit (inputs.hyprland.packages.${pkgs.system}) hyprland xdg-desktop-portal-hyprland;
in

{
  home.stateVersion = "25.11";

  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlays.default ];

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
      ".config/sway" # Added Sway config directory
      ".config/libreoffice"
      ".config/qBittorrent"
      ".config/PrusaSlicer"
      ".config/SuperSlicer"
      ".config/syncthing"
      ".config/waybar"
      ".config/obsidian"
      ".config/antigravity"
      ".config/matterhorn"
      ".gnupg"
      ".local/share/Steam"
      ".local/share/direnv"
      ".local/share/keyrings"
      ".local/share/nvim"
      ".local/share/antigravity"
      ".local/share/qBittorrent"
      ".local/state/nvim"
      ".local/state/syncthing"
      ".mozilla"
      ".nixops"
      ".ollama"
      ".ssh"
      ".thunderbird"
      ".tmux/plugins"
      ".cargo"
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

  # Services
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

  # Development tools (user-level)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  # ZSH Configuration
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
      ll = "ls -l";
      update = "export NIXPKGS_ALLOW_BROKEN=1; sudo nixos-rebuild boot --impure --flake '/persist/nix-config#'$(hostname) --max-jobs 2 --cores 4";
      update-test = "export NIXPKGS_ALLOW_BROKEN=1; sudo nixos-rebuild test --impure --flake '/persist/nix-config#'$(hostname) --max-jobs 2 --cores 4";
      update-full = "sudo nix flake update; update";
      update-safe = "sudo nix flake update nixpkgs home-manager; update";
      history = "history 0";
      history-stat = "history | awk '{print \\$2}' | sort | uniq -c | sort -n -r | head";
    };

    # Your working init configuration
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        if [ -z "$TMUX" ] && [ "$XDG_SESSION_TYPE" != "tty" ]
        then
          tmux attach -t TMUX || tmux new -s TMUX;
          return;
        fi
      '')

      # Your custom init before comp init
      (lib.mkOrder 550 ''
        ${builtins.readFile ./dotfiles/.zshrcInitExtraBeforeCompInit}
      '')

      # Your custom init extra
      ''
        ${builtins.readFile ./dotfiles/.zshrcInitExtra}
      ''
    ];

    completionInit = ''
      # use cache and refresh in separate thread
      autoload -Uz compinit; compinit -C
      (autoload -Uz compinit; compinit &)
    '';

    # Your working history configuration
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      ignoreDups = false;
      ignoreSpace = true;
      path = "/persist/sync/.zsh_history";
      share = true;
      size = 67108864;
      save = 33554432;
    };

    localVariables = {
      RANDOM_VARIABLE_TEST = "dummy";
    };
  };

  # Editor configuration
  programs.neovim = {
    # package = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.neovim-unwrapped;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Hyprland configuration (only if enabled at system level)
  wayland.windowManager.hyprland = lib.mkIf osConfig.desktop.hyprland.enable {
    enable = true;
    package = hyprland;
    extraConfig = ''
      ${builtins.readFile ./dotfiles/.config/hypr/hyprland.conf}
    '';
  };

  # Sway configuration (only if enabled at system level)
  # wayland.windowManager.sway = lib.mkIf osConfig.desktop.sway.enable {
  #   enable = true;
  #   config = null; # We'll use the config file instead
  #   # extraConfig = ''
  #   #   include ~/.config/sway/config
  #   # '';
  # };

  # Dotfiles and configuration files (as you had them)
  home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink /persist/nix-config/dotfiles/.tmux.conf;
  home.file.".tmux/plugins/tpm".source = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "v3.1.0";
    hash = "sha256-CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
  };

  home.file.".config/git/config".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/git/config";
  home.file.".config/git/config.szn".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/git/config.szn";
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink /persist/nvim;
  home.file.".config/nvim".recursive = true;
  home.file.".config/opencode".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/opencode";
  home.file.".config/opencode".recursive = true;
  home.file.".config/kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/kitty/kitty.conf";
  home.file.".ssh/config".source = config.lib.file.mkOutOfStoreSymlink /persist/nix-config/dotfiles/.ssh/config;
  home.file.".config/hypr/hyprpaper.conf".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/hypr/hyprpaper.conf";
  # home.file.".config/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/hypr/hyprland.conf";
  home.file.".config/waybar/config".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/waybar/config";
  home.file.".config/waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/waybar/style.css";

  # Add Sway config file
  home.file.".config/sway/config".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/sway/config";
  # home.file.".config/i3status/config".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/i3status/config";
  home.file.".config/swaylock/config".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/swaylock/config";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
