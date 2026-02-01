{ config, lib, pkgs, ... }:

{
  imports = [
    ./system.nix
    # Only include custom service modules here
    # Built-in services (openssh, printing, plex, ollama) are configured directly
  ];

  options.services = {
    enable = lib.mkEnableOption "system services";
  };

  config = lib.mkIf config.services.enable {
    # Configure built-in NixOS services here
    services.openssh.enable = true;

    services.printing = {
      enable = true;
      drivers = [ pkgs.brlaser ]; # Brother printer driver
    };

    # Enable Avahi for network printer discovery
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Early OOM daemon - kills processes before system becomes unresponsive
    services.earlyoom = {
      enable = true;
      enableNotifications = true; # Show notifications when killing processes
      freeMemThreshold = 10; # Minimum available memory percentage
      freeSwapThreshold = 10; # Minimum available swap percentage
    };

    # zram - compressed swap in RAM
    zramSwap = {
      enable = true;
      memoryPercent = 50; # Use up to 50% of RAM for compressed swap
    };
  };
}
