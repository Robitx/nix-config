{ config, lib, pkgs, ... }:

{
  options.development.tools.antigravity-fhs = {
    enable = lib.mkEnableOption "Antigravity FHS development environment";
  };

  config = lib.mkIf config.development.tools.antigravity-fhs.enable {
    environment.systemPackages = with pkgs; [
      antigravity-fhs
    ];
  };
}
