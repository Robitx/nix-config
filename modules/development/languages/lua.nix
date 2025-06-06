{ config, lib, pkgs, ... }:

{
  options.development.languages.lua = {
    enable = lib.mkEnableOption "Lua development environment";

    variant = lib.mkOption {
      type = lib.types.enum [ "lua" "luajit" ];
      default = "luajit";
      description = "Lua implementation to use";
    };

    enableNeovimSupport = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include packages commonly used for Neovim configuration";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional Lua-related packages";
    };
  };

  config = lib.mkIf config.development.languages.lua.enable {
    environment.systemPackages = with pkgs; [
      # Language server
      lua-language-server
      
      # Formatter
      stylua
      
    ] ++ lib.optionals (config.development.languages.lua.variant == "lua") [
      lua
      luaPackages.luarocks
      luaPackages.luacheck
      
    ] ++ lib.optionals (config.development.languages.lua.variant == "luajit") [
      luajit
      luajitPackages.luarocks
      luajitPackages.luacheck
      
    ] ++ lib.optionals config.development.languages.lua.enableNeovimSupport [
      # Neovim-related Lua packages
      tree-sitter
      
    ] ++ config.development.languages.lua.extraPackages;

    environment.variables = lib.optionalAttrs config.development.languages.lua.enableNeovimSupport {
      # Tree-sitter parsers path for Neovim
      TREE_SITTER_DIR = "${pkgs.tree-sitter}/lib";
    };
  };
}
