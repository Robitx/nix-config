{ config, lib, pkgs, ... }:

{
  options.shell.zsh = {
    enable = lib.mkEnableOption "Zsh shell configuration";

    enableAutosuggestions = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable zsh autosuggestions";
    };

    enableSyntaxHighlighting = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable syntax highlighting";
    };

    enableCompletion = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable standard zsh completion (can be slow)";
    };

    enableTmuxAutoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically start tmux in non-tty sessions";
    };

    historySize = lib.mkOption {
      type = lib.types.int;
      default = 16777216;
      description = "History size in memory";
    };

    historySave = lib.mkOption {
      type = lib.types.int;
      default = 8388608;
      description = "Number of history entries to save to file";
    };

    historyFile = lib.mkOption {
      type = lib.types.str;
      default = "/persist/sync/.zsh_history";
      description = "Path to history file";
    };

    customAliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Custom shell aliases";
      example = {
        ll = "ls -l";
        la = "ls -la";
      };
    };

    nixosAliases = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable NixOS-specific aliases (update, rebuild, etc.)";
    };
  };

  config = lib.mkIf config.shell.zsh.enable {
    programs.zsh = {
      enable = true;
      
      # Oh My Zsh can be added here if desired
      # ohMyZsh = {
      #   enable = true;
      #   theme = "robbyrussell";
      # };
    };

    # Install additional zsh tools
    environment.systemPackages = with pkgs; [
      fzf  # Required for fuzzy finding
    ] ++ lib.optionals config.shell.zsh.enableSyntaxHighlighting [
      # Syntax highlighting is handled by home-manager usually
    ];

    # Global zsh configuration
    environment.etc."zshrc.local".text = ''
      # Global zsh configuration
      # This runs for all users before their personal zshrc
      
      # Disable ctrl+S ctrl+Q behavior in terminal
      stty -ixon
      
      # Set terminal title
      print -Pn "\e]0; %n@%M: %~\a"
    '';

    # Environment variables that work well with zsh
    environment.variables = {
      # Ensure proper terminal type
      TERM = lib.mkDefault "screen-256color";
    };
  };
}
