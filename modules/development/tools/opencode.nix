{ config, lib, pkgs, ... }:

{
  options.development.tools.opencode = {
    enable = lib.mkEnableOption "OpenCode development tools";

    enableExtensions = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include recommended VS Code extensions";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional OpenCode-related packages";
    };
  };

  config = lib.mkIf config.development.tools.opencode.enable {
    environment.systemPackages = with pkgs; [
      # Core OpenCode tools
      opencode
      
    ] ++ lib.optionals config.development.tools.opencode.enableExtensions [
      # Recommended extensions would be included here
      # These would need to be packaged separately
    ] ++ config.development.tools.opencode.extraPackages;

    # OpenCode shell aliases
    environment.shellAliases = {
      oc = "opencode";
    };
  };
}

