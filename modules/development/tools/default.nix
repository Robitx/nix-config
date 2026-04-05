{ config, lib, pkgs, ... }:

{
  imports = [
    ./vscode.nix
    ./git.nix
    ./kubernetes.nix
    ./k3s.nix
    ./opencode.nix
    ./antigravity-fhs.nix
  ];

  # This module aggregates all development tools
}
