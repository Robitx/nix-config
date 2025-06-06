{ config, lib, pkgs, ... }:

{
  options.services.system = {
    optimizeSystemd = lib.mkEnableOption "systemd optimizations";

    fileDescriptorLimit = lib.mkOption {
      type = lib.types.int;
      default = 1048576;
      description = "Maximum number of file descriptors";
    };

    timeoutStop = lib.mkOption {
      type = lib.types.str;
      default = "10s";
      description = "Default timeout for stopping services";
    };

    timeoutAbort = lib.mkOption {
      type = lib.types.str;
      default = "10s";
      description = "Default timeout for aborting services";
    };

    rebootWatchdog = lib.mkOption {
      type = lib.types.str;
      default = "10s";
      description = "Reboot watchdog timeout";
    };

    shutdownWatchdog = lib.mkOption {
      type = lib.types.str;
      default = "10s";
      description = "Shutdown watchdog timeout";
    };
  };

  config = lib.mkIf config.services.system.optimizeSystemd {
    systemd.extraConfig = ''
      DefaultLimitNOFILE=${toString config.services.system.fileDescriptorLimit}
      DefaultLimitMEMLOCK=infinity
      DefaultTimeoutStopSec=${config.services.system.timeoutStop}
      DefaultTimeoutAbortSec=${config.services.system.timeoutAbort}
      RebootWatchdogSec=${config.services.system.rebootWatchdog}
      ShutdownWatchdogSec=${config.services.system.shutdownWatchdog}
    '';

    systemd.user.extraConfig = ''
      DefaultLimitNOFILE=${toString config.services.system.fileDescriptorLimit}
      DefaultLimitMEMLOCK=infinity
      DefaultTimeoutStopSec=${config.services.system.timeoutStop}
    '';
  };
}
