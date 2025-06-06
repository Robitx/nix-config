{ config, lib, pkgs, ... }:

{
  imports = [
    ./vscode.nix
    ./git.nix
    ./kubernetes.nix
  ];

  # This module aggregates all development tools
}
