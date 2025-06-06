{ config, lib, pkgs, ... }:

{
  options.shell.terminal = {
    enable = lib.mkEnableOption "terminal emulator";
    
    emulator = lib.mkOption {
      type = lib.types.enum [ "kitty" "alacritty" "wezterm" ];
      default = "kitty";
      description = "Terminal emulator to use";
    };
  };

  config = lib.mkIf config.shell.terminal.enable {
    environment.systemPackages = with pkgs; 
      if config.shell.terminal.emulator == "kitty" then [ kitty ]
      else if config.shell.terminal.emulator == "alacritty" then [ alacritty ]
      else if config.shell.terminal.emulator == "wezterm" then [ wezterm ]
      else [];

    # Set default terminal
    environment.sessionVariables = {
      TERMINAL = config.shell.terminal.emulator;
    };
  };
}
