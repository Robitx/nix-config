{ config, lib, pkgs, ... }:

{
  services.openssh.enable = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ]; # Brother printer driver
  };

  services.plex = {
    enable = true;
    dataDir = "/plex/var";
    openFirewall = true;
  };

  virtualisation.docker.enable = true;

  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576
    DefaultLimitMEMLOCK=infinity
    DefaultTimeoutStopSec=10s
    DefaultTimeoutAbortSec=10s
    RebootWatchdogSec=10s
    ShutdownWatchdogSec=10s
  '';

  systemd.user.extraConfig = ''
    DefaultLimitNOFILE=1048576
    DefaultLimitMEMLOCK=infinity
    DefaultTimeoutStopSec=10s
  '';
}
