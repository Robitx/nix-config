{ config, lib, pkgs, ... }:

{
  imports = [
    ./vscode.nix
    ./git.nix
    ./kubernetes.nix
    ./opencode.nix
    ./antigravity-fhs.nix
  ];

  # This module aggregates all development tools
}
