{ config, lib, pkgs, ... }:

{
  options.development.tools.kubernetes = {
    enable = lib.mkEnableOption "Kubernetes development tools";

    enableHelm = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include Helm package manager";
    };

    enableLocalCluster = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Include tools for local Kubernetes clusters (kind, minikube)";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional Kubernetes-related packages";
    };
  };

  config = lib.mkIf config.development.tools.kubernetes.enable {
    environment.systemPackages = with pkgs; [
      # Core Kubernetes tools
      kubectl
      kubectx
      
    ] ++ lib.optionals config.development.tools.kubernetes.enableHelm [
      # Helm package manager
      kubernetes-helm
      
    ] ++ lib.optionals config.development.tools.kubernetes.enableLocalCluster [
      # Local cluster tools
      kind
      minikube
      
    ] ++ config.development.tools.kubernetes.extraPackages;

    # Kubernetes shell completion and aliases
    environment.shellAliases = {
      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get services";
      kgd = "kubectl get deployments";
      kdp = "kubectl describe pod";
      kds = "kubectl describe service";
      kdd = "kubectl describe deployment";
    };

    # Enable bash completion for kubectl
    programs.bash.completion.enable = true;
  };
}
