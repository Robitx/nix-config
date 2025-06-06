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

    # Enable Docker
    virtualisation.docker.enable = true;
  };
}
