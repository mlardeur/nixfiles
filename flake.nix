{
  description = "NixOS configuration";

  inputs = {

    # Default to the nixos-unstable branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    #Latest stable branch of nixpkgs, used for version rollback
    # The current latest version is 23.05
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixGL
    nixgl.url = "github:guibou/nixGL";

    # Nix Colors
    nix-colors.url = "github:misterio77/nix-colors";

  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nixgl, ... } @ inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
        overlays = [ nixgl.overlay ];
      };
      pkgs-stable = import nixpkgs-stable {
        system = system;
        config.allowUnfree = true;
        overlays = [ nixgl.overlay ];
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      # NixOS configuration entrypoint available through
      # 'sudo nixos-rebuild switch --flake .#hostname'
      nixosConfigurations = {
        athena = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/athena/configuration.nix
          ];
        };
      };

      # Standalone home-manager configuration entrypoint available through
      # 'home-manager switch --flake .#username@hostname'
      homeConfigurations = {
        "maxime@athena" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/athena/maxime.nix
          ];
        };
        "zion@zion" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/zion
          ];
        };
        "mlardeur@maxime-dell" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/maxime-dell
          ];
        };
      };
    };
}
