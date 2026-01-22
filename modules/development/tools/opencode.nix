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

    # Smart 'oc' function that detects work directory
    environment.interactiveShellInit = ''
      oc() {
        local OPENCODE_BIN="/backup/pgit/opencode/packages/opencode/dist/opencode-linux-x64/bin/opencode"
        if [[ "$PWD" == "/backup/szngit"* ]]; then
          (
            export OPENCODE_CONFIG_DIR=~/.config/opencode-work
            export OPENCODE_DATA_DIR=~/.local/share/opencode-work
            export OPENCODE_STATE_DIR=~/.local/state/opencode-work
            export OPENCODE_CACHE_DIR=~/.cache/opencode-work
            "$OPENCODE_BIN" "$@"
          )
        else
          "$OPENCODE_BIN" "$@"
        fi
      }
    '';

    # OpenCode shell aliases
    environment.shellAliases = {
      # Work Mode (GitHub Copilot)
      ocw = "export OPENCODE_CONFIG_DIR=~/.config/opencode-work && export OPENCODE_DATA_DIR=~/.local/share/opencode-work && export OPENCODE_STATE_DIR=~/.local/state/opencode-work && export OPENCODE_CACHE_DIR=~/.cache/opencode-work && /backup/pgit/opencode/packages/opencode/dist/opencode-linux-x64/bin/opencode";
      
      # Local development build (temporary until PR #8963 merges)
      ocl = "/backup/pgit/opencode/packages/opencode/dist/opencode-linux-x64/bin/opencode";
      
      # Work Mode with local build
      oclw = "export OPENCODE_CONFIG_DIR=~/.config/opencode-work && export OPENCODE_DATA_DIR=~/.local/share/opencode-work && export OPENCODE_STATE_DIR=~/.local/state/opencode-work && export OPENCODE_CACHE_DIR=~/.cache/opencode-work && /backup/pgit/opencode/packages/opencode/dist/opencode-linux-x64/bin/opencode";
    };
  };
}

