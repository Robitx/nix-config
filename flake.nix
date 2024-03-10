{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-autocomplete = {
      url = "github:marlonrichert/zsh-autocomplete/main";
      flake = false;
    };

  };

  outputs = {nixpkgs, impermanence, home-manager, ...} @ inputs:
  {
    nixosConfigurations.tibor480 = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.disko.nixosModules.default
        (import ./disko.nix { device = "/dev/nvme0n1"; })

        ./hardware-configuration/tibor480.nix
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
