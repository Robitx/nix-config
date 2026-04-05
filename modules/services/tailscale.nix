{ config, lib, pkgs, ... }:

{
  options.services.networking.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN service";
    
    useRoutingFeatures = lib.mkOption {
      type = lib.types.enum [ "none" "client" "server" "both" ];
      default = "server";
      description = ''
        Enables settings required for Tailscale's routing features.
        - "client": Use Tailscale as a client (loose reverse path filtering)
        - "server": Act as a server for other devices (IP forwarding enabled)
        - "both": Enable both client and server features
        - "none": No special routing features
      '';
    };
  };

  config = lib.mkIf config.services.networking.tailscale.enable {
    # Enable Tailscale service
    services.tailscale = {
      enable = true;
      useRoutingFeatures = config.services.networking.tailscale.useRoutingFeatures;
    };

    # Firewall configuration for Tailscale
    networking.firewall = {
      checkReversePath = "loose"; # Required for Tailscale
      trustedInterfaces = [ "tailscale0" ];
    };

    # Add Tailscale CLI to system packages
    environment.systemPackages = with pkgs; [
      tailscale
    ];
  };
}
