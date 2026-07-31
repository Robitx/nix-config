{ config, lib, pkgs, secrets, osConfig, inputs, ... }:

let
  inherit (inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}) hyprland xdg-desktop-portal-hyprland;
in

{
  home.stateVersion = "25.11";

  home.username = "tibor";
  home.homeDirectory = "/home/tibor";

  # Persistence configuration
  home.persistence."/persist" = {
    directories = [
      ".cache"
      ".config/Signal"
      ".config/dconf"
      ".config/ghostty"
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
      ".local/share/opencode"
      ".local/share/opencode-work"
      ".local/share/qBittorrent"
      ".local/state/nvim"
      ".local/state/opencode"
      ".local/state/opencode-work"
      ".local/state/syncthing"
      ".mozilla"
      ".nixops"
      ".ollama"
      ".ssh"
      ".thunderbird"
      ".tmux/plugins"
      ".cargo"
      ".vscode"
      ".antigravity"
      ".gemini"
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
  };

  # Theme and cursor configuration
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    gtk4.theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
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

  # XDG MIME type associations
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "x-scheme-handler/sgnl" = "signal.desktop";
      "x-scheme-handler/signalcaptcha" = "signal.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "video/mp4" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "audio/mpeg" = "vlc.desktop";
      "audio/flac" = "vlc.desktop";
      # LibreOffice Writer - Word documents
      "application/msword" = "writer.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.template" = "writer.desktop";
      "application/vnd.oasis.opendocument.text" = "writer.desktop";
      # LibreOffice Calc - Spreadsheets
      "application/vnd.ms-excel" = "calc.desktop";
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "calc.desktop";
      "application/vnd.openxmlformats-officedocument.spreadsheetml.template" = "calc.desktop";
      "application/vnd.oasis.opendocument.spreadsheet" = "calc.desktop";
      # LibreOffice Impress - Presentations
      "application/vnd.ms-powerpoint" = "impress.desktop";
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "impress.desktop";
      "application/vnd.openxmlformats-officedocument.presentationml.template" = "impress.desktop";
      "application/vnd.oasis.opendocument.presentation" = "impress.desktop";
    };
    associations.added = {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "x-scheme-handler/sgnl" = "signal.desktop";
      "x-scheme-handler/signalcaptcha" = "signal.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "video/mp4" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "audio/mpeg" = "vlc.desktop";
      "audio/flac" = "vlc.desktop";
      # LibreOffice Writer - Word documents
      "application/msword" = "writer.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
      "application/vnd.openxmlformats-officedocument.wordprocessingml.template" = "writer.desktop";
      "application/vnd.oasis.opendocument.text" = "writer.desktop";
      # LibreOffice Calc - Spreadsheets
      "application/vnd.ms-excel" = "calc.desktop";
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "calc.desktop";
      "application/vnd.openxmlformats-officedocument.spreadsheetml.template" = "calc.desktop";
      "application/vnd.oasis.opendocument.spreadsheet" = "calc.desktop";
      # LibreOffice Impress - Presentations
      "application/vnd.ms-powerpoint" = "impress.desktop";
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "impress.desktop";
      "application/vnd.openxmlformats-officedocument.presentationml.template" = "impress.desktop";
      "application/vnd.oasis.opendocument.presentation" = "impress.desktop";
    };
  };

  # Force overwrite existing mimeapps.list files
  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;

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
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
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

  # Editor configuration - package only, config managed externally at /persist/nvim
  home.packages = [
    inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

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
  home.file.".config/opencode".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/opencode";
  home.file.".config/opencode".recursive = true;
  home.file.".config/opencode-work".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/opencode-work";
  home.file.".config/opencode-work".recursive = true;
  home.file.".config/ghostty/config.ghostty".source = config.lib.file.mkOutOfStoreSymlink "/persist/nix-config/dotfiles/.config/ghostty/config.ghostty";
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
