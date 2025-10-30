{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };
    # impermanence.url = "github:nix-community/impermanence/63f4d0443e32b0dd7189001ee1894066765d18a5";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-autocomplete = {
      url = "github:marlonrichert/zsh-autocomplete/main";
      flake = false;
    };
    aquamarine.url = "github:hyprwm/aquamarine";
    # aquamarine.url = "github:hyprwm/aquamarine/v0.8.0";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland.url = "github:hyprwm/Hyprland/v0.49.0?submodules=true";
    hyprland.inputs.aquamarine.follows = "aquamarine";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

  };

  nixConfig = {
    extra-substituters = [
      "https://colmena.cachix.org"
      "https://hyprland.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org" # Ensure this is prioritized
    ];
    extra-trusted-public-keys = [
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { nixpkgs, impermanence, home-manager, ... } @ inputs:
    {
      nixosConfigurations.tibor480 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.disko.nixosModules.default
          (import ./disko.nix { device = "/dev/nvme0n1"; })

          ./modules/hardware/tibor480.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.tibor = import ./home.nix;
            };
          }

          inputs.impermanence.nixosModules.impermanence
        ];
      };

      nixosConfigurations.tiborzen = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.disko.nixosModules.default
          (import ./disko.nix { device = "/dev/nvme0n1"; })

          ./modules/hardware/tiborzen.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.tibor = import ./home.nix;
            };
          }

          inputs.impermanence.nixosModules.impermanence
        ];
      };
    };
}
