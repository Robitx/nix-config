{ config, lib, pkgs, secrets, osConfig, inputs, ... }:

{
  home.stateVersion = "23.11"; # Please read the comment before changing.

  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];


  home.username = "tibor";
  home.homeDirectory = "/home/tibor";

  home.persistence."/persist/home/tibor" = {
    removePrefixDirectory = false;
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      "VirtualBox VMs"
      ".gnupg"
      ".ssh"
      ".nixops"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".cache"
      ".config/google-chrome"
      ".config/Signal"
      ".config/skypeforlinux"
      ".thunderbird"
      ".local/state/syncthing"
      ".config/syncthing"
      ".config/dconf" # gnome
      ".config/hypr"
      ".config/waybar"
      ".tmux/plugins"
      ".local/share/nvim"
      ".local/state/nvim"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    files = [
      ".screenrc"
      ".bash_history"
      # ".zsh_history"
      # ".config/gnome-initial-setup-done" # gnome
    ];
    allowOther = true;
  };


  services.syncthing.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs ; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!" '')

    openvpn
    networkmanager
    wdisplays

    waybar
    hyprpaper
    networkmanagerapplet

    gvfs
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin


    nurl
    # wl-clipboard
    tmux

    kubectx
    kubectl

    vscode

    go
    gopls
    golint

    git
    tig

    jq

    tree
    htop
    killall
    dnsutils
    dig
    geoip
    whois
    ipcalc
    ripgrep
    fd
    nodejs_18
    luajitPackages.luarocks

    baobab
    gparted

    gnumake


    ccal

    p7zip
    cabextract
    unrar
    unzip
    zip
    xz
    zstd

    grim
    slurp



    nerdfonts
    # jetbrains-mono

    tree-sitter
    fzf
    vimPlugins.telescope-fzf-native-nvim

    wget
    curl
    sshfs
    
    kitty

    vivaldi
    google-chrome


    thunderbird
    skypeforlinux
    signal-desktop

    gimp

    sox
    vlc

    # python311Full
    (python311.withPackages (p: with p; [
      python
      pytz
      websockets
      urwid
      requests
      tzlocal
      certifi
      docopt
      elastic-transport
      elasticsearch
      elasticsearch-dsl
      pysocks
      urllib3
      pip
      black
      aiohttp # async HTTP
      beautifulsoup4 # web scraping
      ipython # interactive shell
      jupyter # interactive notebooks
      matplotlib # plots
      networkx # graphs
      numpy # numerical computation
      pandas # data analysis
      pylint # static checking
      pwntools
      setuptools # setup.py
      scipy
      scikit-learn
      z3 # Z3 theorem prover
      scapy
      opencv4 # opencv
    ]))
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tibor/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    enableAutosuggestions = false;
    plugins = [
      { name = "zsh-autocomplete"; src = inputs.zsh-autocomplete; }
    ];
    syntaxHighlighting = {
      enable = true;
    };
    shellAliases = {
      lah = "ls -lah";
      update = "sudo nixos-rebuild boot --impure --flake '/persist/nix-config#'$(hostname)";
      history = "history 0";
      history-stat = "history | awk '{print \$2}' | sort | uniq -c | sort -n -r | head";
    };

    initExtraFirst = ''
      if [ -z "$TMUX" ] && [ "$XDG_SESSION_TYPE" != "tty" ]
      then
        tmux attach -t TMUX || tmux new -s TMUX;
	return;
      fi
    '';

    initExtraBeforeCompInit = ''
      # HERE init extra before compinit

      ${builtins.readFile ./dotfiles/.zshrcInitExtraBeforeCompInit}

    '';

    completionInit = ''
      # use cache and refresh in separate thread
      autoload -Uz compinit; compinit -C
      (autoload -Uz compinit; compinit &)
    '';


    # zprof.enable = true;

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true; 
      ignoreDups = true;
      # ignorePatterns
      ignoreSpace = true;
      path = "/persist/sync/.zsh_history";
      share = true;
      size = 16777216;
      save = 8388608;
    };



    # ${builtins.readFile ./zshrc}
    initExtra= ''
      # HERE init extra
      ${builtins.readFile ./dotfiles/.zshrcInitExtra}
    '';

    localVariables = {
      RANDOM_VARIABLE_TEST = "dummy";
    };
  };


  # home.file.".zshrc".source = ./dotfiles/.zshrc;


  home.file.".tmux.conf".source = ./dotfiles/.tmux.conf;
  # nurl https://github.com/tmux-plugins/tpm v3.1.0
  home.file.".tmux/plugins/tpm".source = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "v3.1.0";
    hash = "sha256-CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
  };

  # programs.git = {
  #   enable = true;
  #   userName = "Tibor Schmidt";
  #   userEmail = "robitx@gmail.com";
  # };


  home.file.".config/git/config".source = ./dotfiles/.config/git/config;
  home.file.".config/git/config.szn".source = ./dotfiles/.config/git/config.szn;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # xdg.configFile.nvim.source = /persist/nvim;
  # xdg.configFile.nvim.recursive = true;
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink  /persist/nvim;
  home.file.".config/nvim".recursive = true;

  home.file.".config/kitty/kitty.conf".source = ./dotfiles/.config/kitty/kitty.conf;
  # programs.kitty = {
  #   enable = true;
  # };

  wayland.windowManager.hyprland = let
    hostname = osConfig.networking.hostName;
    # Define your monitor setups for different hostnames
    monitorSetup = {
      "tiborzen" = ''
        monitor=DP-1,2560x1440@74.96800,0x0,1
        monitor=DP-3,1920x1200@59.95000,2560x0,1
        monitor=DP-3,transform,1
      '';
      "tibor480" = ''
        monitor=,highres,auto,1
      '';
      # Add more hostnames and their corresponding setups as needed
    };
  in
  {
    enable = true;
    extraConfig = ''
      # hyprland extra config
      ${monitorSetup.${hostname}}
  
      ${builtins.readFile ./dotfiles/.config/hypr/hyprland.conf}
    '';
  };

  # services.kanshi = {
  #   enable = true;
  #   extraConfig = ''
  #   '';
  # };

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

  services.ssh-agent.enable = true;
  home.file.".ssh/config".source = ./dotfiles/.ssh/config;


  home.file.".config/hypr/hyprpaper.conf".source = ./dotfiles/.config/hypr/hyprpaper.conf;
  home.file.".config/waybar/config".source = ./dotfiles/.config/waybar/config;
  home.file.".config/waybar/style.css".source = ./dotfiles/.config/waybar/style.css;


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
