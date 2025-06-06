{ config, lib, pkgs, ... }:

{
  options.desktop.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth support with GUI management";

    powerOnBoot = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to power on Bluetooth adapters on boot";
    };

    enableExperimental = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable experimental Bluetooth features";
    };

    autoConnect = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically connect to known devices";
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional Bluetooth configuration settings";
      example = {
        General = {
          DiscoverableTimeout = 0;
          PairableTimeout = 0;
        };
      };
    };
  };

  config = lib.mkIf config.desktop.bluetooth.enable {
    # Enable Bluetooth hardware support
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = config.desktop.bluetooth.powerOnBoot;
      
      settings = lib.mkMerge [
        # Base settings
        {
          General = {
            Experimental = config.desktop.bluetooth.enableExperimental;
          } // lib.optionalAttrs config.desktop.bluetooth.autoConnect {
            AutoConnect = true;
          };
        }
        
        # User-provided extra settings
        config.desktop.bluetooth.extraSettings
      ];
    };

    # Bluetooth GUI management
    services.blueman.enable = true;

    # Ensure bluetooth group exists
    users.groups.bluetooth = {};

    # System packages for Bluetooth management
    environment.systemPackages = with pkgs; [
      bluez
      bluez-tools
    ];

    # Enable D-Bus for Bluetooth communication
    services.dbus.enable = true;
  };
}
