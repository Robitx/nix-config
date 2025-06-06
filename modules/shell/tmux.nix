{ config, lib, pkgs, ... }:

{
  options.shell.tmux = {
    enable = lib.mkEnableOption "tmux terminal multiplexer";

    defaultShell = lib.mkOption {
      type = lib.types.str;
      default = "zsh";
      description = "Default shell to use in tmux";
    };

    enableMouse = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable mouse support";
    };

    prefix = lib.mkOption {
      type = lib.types.str;
      default = "C-a";
      description = "Tmux prefix key";
    };

    enableVimMode = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable vim-style key bindings";
    };

    enablePluginManager = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable TPM (Tmux Plugin Manager)";
    };

    startIndex = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Start window and pane numbering at this index";
    };

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "screen-256color";
      description = "Default terminal type";
    };

    statusPosition = lib.mkOption {
      type = lib.types.enum [ "top" "bottom" ];
      default = "top";
      description = "Position of status bar";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional tmux configuration";
    };
  };

  config = lib.mkIf config.shell.tmux.enable {
    programs.tmux = {
      enable = true;
      
      # Use the updated tmux from overlays if available
      # package = pkgs.tmux;
    };

    environment.systemPackages = with pkgs; [
      tmux
    ];

    # System-wide tmux configuration
    environment.etc."tmux.conf".text = ''
      # System-wide tmux configuration
      
      # Set shell
      set -g default-shell ${pkgs.${config.shell.tmux.defaultShell}}/bin/${config.shell.tmux.defaultShell}
      
      # Default terminal
      set -g default-terminal "${config.shell.tmux.terminal}"
      
      # Enable mouse
      ${lib.optionalString config.shell.tmux.enableMouse "set -g mouse on"}
      
      # Set prefix
      unbind C-b
      set -g prefix ${config.shell.tmux.prefix}
      bind ${config.shell.tmux.prefix} send-prefix
      
      # True colors
      set -sa terminal-overrides ',xterm*:Tc'
      
      # Start windows and panes at ${toString config.shell.tmux.startIndex}
      set -g base-index ${toString config.shell.tmux.startIndex}
      setw -g pane-base-index ${toString config.shell.tmux.startIndex}
      set -g renumber-windows on
      
      # Status bar position
      set -g status-position ${config.shell.tmux.statusPosition}
      
      ${lib.optionalString config.shell.tmux.enableVimMode ''
      # VI mode
      setw -g mode-keys vi
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe 'wl-copy'
      # don't exit copy mode after dragging with mouse
      unbind -T copy-mode-vi MouseDragEnd1Pane
      ''}
      
      # Session management key bindings
      bind -n C-s display-popup -E "\
          tmux list-sessions | sed -E 's/:.*$//' |\
          fzf --reverse |\
          xargs tmux switch-client -t"
      
      bind -n C-n command-prompt -p 'New session name:' 'new-session -s %1'
      
      ${config.shell.tmux.extraConfig}
    '';

    # Environment variables for tmux
    environment.variables = {
      # Ensure tmux can find the correct shell
      SHELL = "/run/current-system/sw/bin/${config.shell.tmux.defaultShell}";
    };
  };
}
