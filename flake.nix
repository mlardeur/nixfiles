{
  description = "NixOS configuration";

  inputs = {
    # Default to the nixos-unstable branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #Latest stable branch of nixpkgs, used for version rollback
    # The current latest version is 24.11
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Home Manager Stable
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    # NixGL
    nixgl.url = "github:guibou/nixGL";
    # Nix Colors
    nix-colors.url = "github:misterio77/nix-colors";
    # Sops Secrets Security 
    sops-nix.url = "github:Mic92/sops-nix";
    # Faltpak module
    flatpaks.url = "github:gmodena/nix-flatpak/main";
    # Flathub Cli
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, home-manager-stable, nixgl, flatpaks, fh, ... } @ inputs:
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
            {
              environment.systemPackages = [ fh.packages.x86_64-linux.default ];
            }
            ./hosts/athena/configuration.nix
          ];
        };
        hera = nixpkgs.lib.nixosSystem {
          modules = [
            {
              environment.systemPackages = [ fh.packages.x86_64-linux.default ];
            }
            ./hosts/hera/configuration.nix
          ];
        };
      };

      # Standalone home-manager configuration entrypoint available through
      # 'home-manager switch --flake .#username@hostname'
      homeConfigurations = {
        "maxime@hera" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/hera/maxime.nix
          ];
        };
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
      };
    };
}
