{ config, lib, pkgs, ... }:

{
  system.stateVersion = "25.05";

  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [

    docker-compose

  ];

  security = {
    pki.certificates = [
      ''
        ${builtins.readFile /persist/secrets/root2022.pem}
      ''
    ];
  };
}
