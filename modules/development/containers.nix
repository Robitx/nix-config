{ config, lib, pkgs, ... }:

{
  options.development.containers = {
    enable = lib.mkEnableOption "container development tools";

    enableDocker = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Docker support";
    };

    enablePodman = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Podman as Docker alternative";
    };

    enableDevContainers = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable development container tools";
    };

    enableCI = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable CI/CD tools (act for GitHub Actions)";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional container-related packages";
    };
  };

  config = lib.mkIf config.development.containers.enable {
    # Docker configuration
    virtualisation.docker = lib.mkIf config.development.containers.enableDocker {
      enable = true;
      enableOnBoot = lib.mkDefault true;

      # Use systemd-resolved for DNS in containers
      daemon.settings = {
        dns = [
          "10.3.12.124" # Primary corporate DNS
          "10.3.12.125" # Secondary corporate DNS
          "192.168.86.2" # Local network DNS for public lookups
          # "127.0.0.53"
        ];
      };
    };

    # Podman configuration
    virtualisation.podman = lib.mkIf config.development.containers.enablePodman {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = with pkgs; [
      # Container composition
      docker-compose

    ] ++ lib.optionals config.development.containers.enableDevContainers [
      # Development containers
      devpod

    ] ++ lib.optionals config.development.containers.enableCI [
      # CI/CD tools
      act # Run GitHub Actions locally

    ] ++ config.development.containers.extraPackages;

    # Add users to docker group if Docker is enabled
    users.extraGroups = lib.mkIf config.development.containers.enableDocker {
      docker = { };
    };

    # Useful container aliases
    environment.shellAliases = lib.mkMerge [
      (lib.mkIf config.development.containers.enableDocker {
        dps = "docker ps";
        dpa = "docker ps -a";
        di = "docker images";
        dex = "docker exec -it";
        dlog = "docker logs -f";
        dclean = "docker system prune -af";
      })

      (lib.mkIf config.development.containers.enablePodman {
        pps = "podman ps";
        ppa = "podman ps -a";
        pi = "podman images";
        pex = "podman exec -it";
        plog = "podman logs -f";
        pclean = "podman system prune -af";
      })
    ];

    # Enable container registry authentication helpers
    environment.etc."containers/policy.json".text = builtins.toJSON {
      default = [{ type = "insecureAcceptAnything"; }];
    };
  };
}
