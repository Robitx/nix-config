{ config, lib, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./terminal.nix
  ];

  options.shell = {
    enable = lib.mkEnableOption "shell configuration";

    defaultShell = lib.mkOption {
      type = lib.types.enum [ "zsh" "bash" ];
      default = "zsh";
      description = "Default shell for users";
    };
  };

  config = lib.mkIf config.shell.enable {
    # Enable the default shell system-wide
    programs.${config.shell.defaultShell}.enable = true;

    # Set as default shell for users
    users.defaultUserShell = pkgs.${config.shell.defaultShell};
  };
}
