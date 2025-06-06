# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./modules/system/boot.nix
      ./modules/system/base.nix
      ./modules/desktop/hyprland.nix
      ./modules/users/tibor.nix
      ./modules/services/default.nix
      # Include the results of the hardware scan.
    ];




  nixpkgs.overlays = [
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




  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/docker"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
  };


}

