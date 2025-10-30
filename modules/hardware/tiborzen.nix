{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "tiborzen";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.xserver.videoDrivers = [ "nvidia" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];
  hardware.graphics.extraPackages = with pkgs; [
    vulkan-validation-layers
  ];
  hardware.nvidia = {
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };


  hardware.nvidia-container-toolkit.enable = true;

  # Set environment variables related to NVIDIA graphics
  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
  ];

  programs.gamemode.enable = true;

  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  # Monitor configuration for tiborzen
  desktop.monitors.hyprlandConfig = ''
    monitor=Unknown-1, disable
    monitor=DP-3,3440x1440@59.98700,0x0,1
    monitor=DP-2,1920x1200@59.95000,3440x0,1
    monitor=DP-2,transform,1
  '';


  # machine specific services
  services.plex = {
    enable = true;
    dataDir = "/plex/var";
    openFirewall = true;
  };

  services.ollama = {
    user = "ollama";
    group = "ollama";
    enable = true;
    # acceleration = "cuda";
    models = "/backup/ollama_models";
  };

}
