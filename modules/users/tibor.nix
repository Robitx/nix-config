{ config, lib, pkgs, ... }:

{
  users.mutableUsers = false;

  users.users."tibor" = {
    isNormalUser = true;
    description = "Tibor Schmidt";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "nix"
    ] ++ lib.optionals config.services.ollama.enable [ "ollama" ];
    hashedPasswordFile = "/persist/nix-config/passwords/tibor";
    shell = pkgs.zsh;
    uid = 1000;
  };

  programs.zsh.enable = true;
}
