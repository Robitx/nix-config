{ config, lib, pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    # Neovim nightly overlay
    inputs.neovim-nightly-overlay.overlays.default
    (final: prev: {
      cliphist = prev.cliphist.overrideAttrs (_old: {
        src = final.fetchFromGitHub {
          owner = "sentriz";
          repo = "cliphist";
          rev = "refs/tags/v0.6.1";
          sha256 = "sha256-tImRbWjYCdIY8wVMibc5g5/qYZGwgT9pl4pWvY7BDlI=";
        };
        vendorHash = "sha256-gG8v3JFncadfCEUa7iR6Sw8nifFNTciDaeBszOlGntU=";
      });
    })
  ];
}

