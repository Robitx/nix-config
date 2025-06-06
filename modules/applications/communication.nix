{ config, lib, pkgs, ... }:

{
  options.applications.communication = {
    enable = lib.mkEnableOption "communication applications";
    
    thunderbird = lib.mkEnableOption "Thunderbird email client";
    signal = lib.mkEnableOption "Signal messenger";
  };

  config = lib.mkIf config.applications.communication.enable {
    environment.systemPackages = with pkgs; lib.optionals config.applications.communication.thunderbird [
      thunderbird
    ] ++ lib.optionals config.applications.communication.signal [
      signal-desktop
    ];
  };
}
