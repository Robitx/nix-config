{ config, lib, pkgs, ... }:

{
  system.stateVersion = "25.11";

  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      # Disabled: corporate DNS doesn't support DNSSEC for internal zones and
      # returns malformed responses that cause resolved to hang indefinitely.
      DNSSEC = "no";
      FallbackDNS = [ "1.1.1.1" "9.9.9.9" ];
      # Also listen on the Docker bridge gateway so build containers can reach
      # resolved. 127.0.0.53 is bound to loopback — unreachable from container
      # network namespaces. 172.17.0.1 is the host as seen from inside containers.
      DNSStubListenerExtra = "172.17.0.1";
    };
  };

  # Local development hostnames — maps k3s/Traefik ingress hosts to the
  # ingress IP so browsers can reach them without editing /etc/hosts manually.
  networking.extraHosts = ''
    192.168.86.143  api.cogiter.local
  '';

  # Allow Docker containers to reach systemd-resolved on the bridge gateway.
  networking.firewall.interfaces."docker0".allowedUDPPorts = [ 53 ];
  networking.firewall.interfaces."docker0".allowedTCPPorts = [ 53 ];

  # Point /etc/resolv.conf at systemd-resolved stub (127.0.0.53).
  # This gives Docker BuildKit and all containers correct DNS in all
  # network contexts: home, work VPN, tailscale.
  environment.etc."resolv.conf".source =
    "/run/systemd/resolve/stub-resolv.conf";

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    download-buffer-size = 268435456; # 256 MiB (default is 64 MiB)
  };

  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [

    docker-compose
    kitty
    ghostty
    neovim
    tmux

  ];

  # security = {
  #   pki.certificates = [
  #     ''
  #       ${builtins.readFile /persist/secrets/root2022.pem}
  #     ''
  #   ];
  # };
}
