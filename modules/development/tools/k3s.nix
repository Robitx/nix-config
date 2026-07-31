{ config, lib, pkgs, ... }:

{
  options.development.tools.k3s = {
    enable = lib.mkEnableOption "k3s lightweight Kubernetes";

    configFile = lib.mkOption {
      type = lib.types.path;
      default = /persist/nix-config/configs/k3s/config.yaml;
      description = "Path to k3s config.yaml file";
    };

    role = lib.mkOption {
      type = lib.types.enum [ "server" "agent" ];
      default = "server";
      description = "Whether to run as server or agent";
    };
  };

  config = lib.mkIf config.development.tools.k3s.enable {
    # Install k3s package
    environment.systemPackages = with pkgs; [
      k3s
    ];

    # Symlink config file to /etc/rancher/k3s/config.yaml (traditional k3s way)
    environment.etc."rancher/k3s/config.yaml".source = config.development.tools.k3s.configFile;

    # Enable k3s service (minimal Nix config - everything else in config.yaml)
    services.k3s = {
      enable = true;
      role = config.development.tools.k3s.role;
      # Config file will be automatically picked up by k3s from /etc/rancher/k3s/config.yaml
    };

    # Allow k3s through firewall
    networking.firewall.allowedTCPPorts = lib.mkIf (config.development.tools.k3s.role == "server") [
      6443 # Kubernetes API
    ];

    # Shell aliases for convenience
    environment.shellAliases = {
      k3s-kubectl = "k3s kubectl";
    };

    # Set KUBECONFIG for kubectl to work with k3s
    environment.variables = {
      KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    };
  };
}
