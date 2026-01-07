{ config, lib, pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    # Neovim nightly overlay
    inputs.neovim-nightly-overlay.overlays.default
    # Have the current version of tmux replaces until the next release.
    # Waiting on this to be in the upsteam: https://github.com/tmux/tmux/pull/3958
    (final: prev: {
      tmux = prev.tmux.overrideAttrs (old: {
        src = final.fetchFromGitHub {
          owner = old.src.owner;
          repo = old.src.repo;
          rev = "5039be657c4263f2539a149199cbc8d6780df1c3";
          hash = "sha256-oH8TTifPSim0b6FJNss6H7IOODjzsj9vBIndT0quvuo=";
        };
        patches = [ ];
      });
    })
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

