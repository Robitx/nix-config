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
      # allow-downgrade is insufficient — it only handles missing DNSSEC, not
      # broken DNSSEC responses.
      DNSSEC = "no";
      FallbackDNS = [ "1.1.1.1" "9.9.9.9" ];
    };
  };

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

  security = {
    pki.certificates = [
      ''
        ${builtins.readFile /persist/secrets/root2022.pem}
      ''
    ];
  };
}
