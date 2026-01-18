{ config, lib, pkgs, ... }:

{
  options.development.languages.javascript = {
    enable = lib.mkEnableOption "JavaScript/TypeScript development environment";

    nodeVersion = lib.mkOption {
      type = lib.types.enum [ "nodejs_18" "nodejs_20" "nodejs_22" "nodejs_24" ];
      default = "nodejs_24";
      description = "Node.js version to install";
    };

    enableTypeScript = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include TypeScript support";
    };

    packageManager = lib.mkOption {
      type = lib.types.enum [ "npm" "yarn" "pnpm" "bun" ];
      default = "npm";
      description = "JavaScript package manager to install";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional JavaScript-related packages";
    };
  };

  config = lib.mkIf config.development.languages.javascript.enable {
    environment.systemPackages = with pkgs; [
      # Node.js runtime
      pkgs.${config.development.languages.javascript.nodeVersion}
      
      # Language servers and tools
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      
      # Linting and formatting
      eslint_d
      
    ] ++ lib.optionals config.development.languages.javascript.enableTypeScript [
      # TypeScript
      typescript
      
    ] ++ lib.optionals (config.development.languages.javascript.packageManager == "yarn") [
      yarn
      
    ] ++ lib.optionals (config.development.languages.javascript.packageManager == "pnpm") [
      nodePackages.pnpm
      
    ] ++ lib.optionals (config.development.languages.javascript.packageManager == "bun") [
      bun
      
    ] ++ config.development.languages.javascript.extraPackages;

    environment.variables = {
      # Node.js environment
      NODE_ENV = lib.mkDefault "development";
    };

    # Configure npm for better security and performance
    environment.etc."npmrc".text = ''
      audit-level=moderate
      fund=false
      update-notifier=false
    '';
  };
}
