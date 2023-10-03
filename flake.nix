{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
  let 
    inherit (self) outputs;
    system = "x86_64-linux";
  in {
    # NixOS configuration entrypoint available through
    # 'sudo nixos-rebuild switch --flake .#hostname'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.maxime = import ./home/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint available through
    # 'home-manager switch --flake .#username@hostname'
    homeConfigurations = {
      "zion@zion" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [
            ./home/zion.nix
          ];
      };
    };
  };
}
