{ config, lib, pkgs, ... }:

{
  options.desktop.development = {
    enable = lib.mkEnableOption "development tools and environments";

    languages = {
      go = lib.mkEnableOption "Go development tools";
      rust = lib.mkEnableOption "Rust development tools";
      python = lib.mkEnableOption "Python development environment";
      javascript = lib.mkEnableOption "JavaScript/TypeScript development tools";
      lua = lib.mkEnableOption "Lua development tools";
      c = lib.mkEnableOption "C/C++ development tools";
    };

    tools = {
      vscode = lib.mkEnableOption "Visual Studio Code";
      git = lib.mkEnableOption "Git and related tools";
      containers = lib.mkEnableOption "Container development tools";
      kubernetes = lib.mkEnableOption "Kubernetes tools";
    };
  };

  config = lib.mkIf config.desktop.development.enable {
    environment.systemPackages = with pkgs; [
      # Core development tools
      gnumake
      tree
      htop
      ripgrep
      fd
      jq
      yq
      curl
      wget

      # Language servers and formatters
      efm-langserver
      nixpkgs-fmt
      nil
      shellcheck
      dotenv-linter
      prettierd
      eslint_d

      # Security and analysis
      trufflehog

      # Documentation and conversion
      pandoc

      # Debugging and profiling
      gdb
      strace

    ]

    ++ lib.optionals config.desktop.development.languages.go [
      go
      gopls
      golines
      revive
      golangci-lint
      delve
    ]

    ++ lib.optionals config.desktop.development.languages.rust [
      rustup
    ]

    ++ lib.optionals config.desktop.development.languages.python [
      pyright
      (python311.withPackages (p: with p; [
        python
        openpyxl
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
        aiohttp
        beautifulsoup4
        ipython
        jupyter
        matplotlib
        minio
        flask
        networkx
        numpy
        pandas
        black
        flake8
        pylint
        isort
        beautysh
        pwntools
        setuptools
        scipy
        scikit-learn
        z3
        scapy
        opencv4
      ]))
    ]

    ++ lib.optionals config.desktop.development.languages.javascript [
      nodejs_24
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      typescript
    ]

    ++ lib.optionals config.desktop.development.languages.lua [
      luajitPackages.luarocks
      luajitPackages.luacheck
      lua-language-server
      stylua
    ]

    ++ lib.optionals config.desktop.development.languages.c [
      clang-tools
      clang_18
      libgcc
    ]

    ++ lib.optionals config.desktop.development.tools.vscode [
      vscode
    ]

    ++ lib.optionals config.desktop.development.tools.git [
      git
      gh
      tig
      commitlint
    ]

    ++ lib.optionals config.desktop.development.tools.containers [
      docker-compose
      act
      devpod
    ]

    ++ lib.optionals config.desktop.development.tools.kubernetes [
      kubectx
      kubectl
    ];

    # Additional language server configurations
    environment.variables = lib.mkIf config.desktop.development.languages.yaml {
      # YAML language server configuration can go here
    };

    # Enable additional services for development
    services = lib.mkIf config.desktop.development.tools.containers {
      # Container-related services would go here if needed
    };
  };
}
