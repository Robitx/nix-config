{ config, lib, pkgs, ... }:

{
  options.development.languages.python = {
    enable = lib.mkEnableOption "Python development environment";

    version = lib.mkOption {
      type = lib.types.enum [ "python39" "python310" "python311" "python312" "python313" ];
      default = "python313";
      description = "Python version to use";
    };

    enableDataScience = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include data science packages (numpy, pandas, matplotlib, etc.)";
    };

    enableJupyter = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include Jupyter notebook support";
    };

    enableWeb = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include web development packages (flask, requests, etc.)";
    };

    enableSecurity = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include security testing packages (pwntools, scapy, etc.)";
    };

    extraPackages = lib.mkOption {
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
      default = p: [];
      description = "Additional Python packages as a function taking python packages as argument";
      example = "p: with p; [ requests beautifulsoup4 ]";
    };
  };

  config = lib.mkIf config.development.languages.python.enable {
    environment.systemPackages = with pkgs; [
      # Language server
      pyright
      
      # Python with selected packages
      (pkgs.${config.development.languages.python.version}.withPackages (p: with p; [
        # Core packages
        python
        pip
        setuptools
        
        # Development tools
        black
        flake8
        pylint
        isort
        ipython
        
      ] ++ lib.optionals config.development.languages.python.enableDataScience [
        # Data science packages
        numpy
        pandas
        matplotlib
        scipy
        scikit-learn
        torch
        
      ] ++ lib.optionals config.development.languages.python.enableJupyter [
        # Jupyter ecosystem
        jupyter
        
      ] ++ lib.optionals config.development.languages.python.enableWeb [
        # Web development
        flask
        requests
        beautifulsoup4
        aiohttp
        urllib3
        websockets
        
      ] ++ lib.optionals config.development.languages.python.enableSecurity [
        # Security tools
        pwntools
        scapy
        
      ] ++ [
        # Additional packages that are commonly needed
        openpyxl
        pytz
        urwid
        tzlocal
        certifi
        docopt
        termcolor
        elastic-transport
        elasticsearch
        elasticsearch-dsl
        pysocks
        minio
        networkx
        z3-solver
        # opencv4
        beautysh
        
      ] ++ (config.development.languages.python.extraPackages p)))
    ];

    environment.variables = {
      # Python environment
      PYTHONPATH = lib.mkDefault "";
    };
  };
}
