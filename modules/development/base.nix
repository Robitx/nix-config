{ config, lib, pkgs, ... }:

{
  options.development.base = {
    enable = lib.mkEnableOption "core development tools";

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional core development packages";
    };
  };

  config = lib.mkIf config.development.base.enable {
    environment.systemPackages = with pkgs; [
      # Core build tools
      gnumake
      cmake
      pkg-config

      # Essential CLI tools
      tree
      htop
      killall
      
      # Search and file tools
      ripgrep
      fd
      fzf
      
      # Data processing
      jq
      yq
      pup
      graphviz
      
      # Network tools
      curl
      wget
      dnsutils
      dig
      whois
      ipcalc
      
      # Documentation and conversion
      pandoc
      
      # Security and analysis
      trufflehog
      
      # Recording and documentation
      asciinema
      
      # Archive tools
      p7zip
      cabextract
      unrar
      unzip
      zip
      xz
      zstd
      
      # System information
      lshw
      
      # Language servers and formatters (generic)
      efm-langserver
      nixpkgs-fmt
      nil
      shellcheck
      dotenv-linter
      prettierd
      
      # File system tools
      sshfs
      
      # Image processing
      imagemagick
      
    ] ++ config.development.base.extraPackages;

    # Environment variables for development
    environment.variables = {
      EDITOR = lib.mkDefault "nvim";
      PAGER = lib.mkDefault "less";
    };

    # Essential development groups
    users.groups.developers = {};
  };
}
