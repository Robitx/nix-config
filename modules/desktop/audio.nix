{ config, lib, pkgs, ... }:

{
  options.desktop.audio = {
    enable = lib.mkEnableOption "audio system with PipeWire";

    lowLatency = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable low-latency audio configuration";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional audio packages to install";
    };
  };

  config = lib.mkIf config.desktop.audio.enable {
    # Enable real-time scheduling for audio
    security.rtkit.enable = true;

    # PipeWire audio system
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # Low-latency configuration
      extraConfig.pipewire = lib.mkIf config.desktop.audio.lowLatency {
        "99-low-latency" = {
          context.properties = {
            default.clock.rate = 48000;
            default.clock.quantum = 32;
            default.clock.min-quantum = 32;
            default.clock.max-quantum = 32;
          };
        };
      };
    };

    # Audio control packages
    environment.systemPackages = with pkgs; [
      pamixer
      pavucontrol
      playerctl
      alsa-utils
      alsa-tools
    ] ++ config.desktop.audio.extraPackages;

    # Ensure audio group exists and add users
    users.groups.audio = {};
  };
}
