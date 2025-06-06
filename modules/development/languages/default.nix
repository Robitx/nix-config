{ config, lib, pkgs, ... }:

{
  imports = [
    ./go.nix
    ./rust.nix
    ./python.nix
    ./javascript.nix
    ./lua.nix
    ./c.nix
  ];

  # This module just aggregates all language-specific modules
  # Individual language options are defined in their respective files
}
