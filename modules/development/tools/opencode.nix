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
      
      # Work Mode (GitHub Copilot)
      ocw = "export OPENCODE_CONFIG_DIR=~/.config/opencode-work && export OPENCODE_DATA_DIR=~/.local/share/opencode-work && export OPENCODE_STATE_DIR=~/.local/state/opencode-work && export OPENCODE_CACHE_DIR=~/.cache/opencode-work && opencode";
      
      # Personal Mode (Google AI Pro / Gemini)
      ocp = "export OPENCODE_CONFIG_DIR=~/.config/opencode-personal && export OPENCODE_DATA_DIR=~/.local/share/opencode-personal && export OPENCODE_STATE_DIR=~/.local/state/opencode-personal && export OPENCODE_CACHE_DIR=~/.cache/opencode-personal && opencode";
      
      # Local development build (temporary until PR #8963 merges)
      ocl = "/backup/pgit/opencode/packages/opencode/dist/opencode-linux-x64/bin/opencode";
      
      # Work Mode with local build
      oclw = "export OPENCODE_CONFIG_DIR=~/.config/opencode-work && export OPENCODE_DATA_DIR=~/.local/share/opencode-work && export OPENCODE_STATE_DIR=~/.local/state/opencode-work && export OPENCODE_CACHE_DIR=~/.cache/opencode-work && /backup/pgit/opencode/packages/opencode/dist/opencode-linux-x64/bin/opencode";
      
      # Personal Mode with local build
      oclp = "export OPENCODE_CONFIG_DIR=~/.config/opencode-personal && export OPENCODE_DATA_DIR=~/.local/share/opencode-personal && export OPENCODE_STATE_DIR=~/.local/state/opencode-personal && export OPENCODE_CACHE_DIR=~/.cache/opencode-personal && /backup/pgit/opencode/packages/opencode/dist/opencode-linux-x64/bin/opencode";
    };
  };
}

