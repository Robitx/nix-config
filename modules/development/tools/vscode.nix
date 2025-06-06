{ config, lib, pkgs, ... }:

{
  options.development.tools.vscode = {
    enable = lib.mkEnableOption "Visual Studio Code";

    variant = lib.mkOption {
      type = lib.types.enum [ "vscode" "vscodium" "vscode-fhs" ];
      default = "vscode";
      description = "VS Code variant to install";
    };

    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "VS Code extensions to install";
      example = "with pkgs.vscode-extensions; [ ms-python.python ]";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional packages for VS Code development";
    };
  };

  config = lib.mkIf config.development.tools.vscode.enable {
    environment.systemPackages = with pkgs; [
      # VS Code variant
      (if config.development.tools.vscode.variant == "vscode" then vscode
       else if config.development.tools.vscode.variant == "vscodium" then vscodium
       else vscode-fhs)
       
    ] ++ config.development.tools.vscode.extraPackages;

    # VS Code configuration directory
    environment.etc."vscode/settings.json".text = builtins.toJSON {
      "telemetry.telemetryLevel" = "off";
      "update.mode" = "none";
      "extensions.autoUpdate" = false;
    };
  };
}
