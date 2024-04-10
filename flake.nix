{
  description = "NixOS configuration";

  inputs = {

    # Default to the nixos-unstable branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    #Latest stable branch of nixpkgs, used for version rollback
    # The current latest version is 23.11
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager Stable
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # NixGL
    nixgl.url = "github:guibou/nixGL";

    # Nix Colors
    nix-colors.url = "github:misterio77/nix-colors";

  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, home-manager-stable, nixgl, ... } @ inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
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
        "zion@zion" = home-manager-stable.lib.homeManagerConfiguration {
          pkgs = pkgs-stable;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/zion
          ];
        };
        "mlardeur@maxime-dell" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs // { overlays = [ nixgl.overlay ]; };
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/maxime-dell/mlardeur.nix
          ];
        };
      };
    };
}
