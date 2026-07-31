{ config, lib, pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    # Neovim nightly overlay
    inputs.neovim-nightly-overlay.overlays.default
  ];
}

