{ config, lib, pkgs, ... }:

{
  options.development.tools.git = {
    enable = lib.mkEnableOption "Git and related development tools";

    enableGitHub = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include GitHub CLI and related tools";
    };

    enableAdvancedTools = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include advanced Git tools (tig, git-lfs, etc.)";
    };

    defaultBranch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      description = "Default branch name for new repositories";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional Git-related packages";
    };
  };

  config = lib.mkIf config.development.tools.git.enable {
    environment.systemPackages = with pkgs; [
      # Core Git
      git
      
      # Commit message linting
      commitlint
      
    ] ++ lib.optionals config.development.tools.git.enableGitHub [
      # GitHub tools
      gh
      
    ] ++ lib.optionals config.development.tools.git.enableAdvancedTools [
      # Advanced Git tools
      tig
      git-lfs
      git-crypt
      
    ] ++ config.development.tools.git.extraPackages;

    # Global Git configuration
    environment.etc."gitconfig".text = ''
      [init]
        defaultBranch = ${config.development.tools.git.defaultBranch}
      
      [pull]
        rebase = false
      
      [core]
        autocrlf = input
      
      [push]
        default = simple
        autoSetupRemote = true
      
      [alias]
        st = status
        co = checkout
        br = branch
        ci = commit
        unstage = reset HEAD --
        last = log -1 HEAD
        visual = !gitk
        nah = !git reset --hard && git clean -df
    '';

    # Enable Git LFS if advanced tools are enabled
    programs.git = lib.mkIf config.development.tools.git.enableAdvancedTools {
      enable = true;
      lfs.enable = true;
    };
  };
}
