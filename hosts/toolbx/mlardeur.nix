{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../home/cli
  ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-terminal-dark;

  # Home Manger needs a bit of information about you and the 
  # paths is should manage.
  home = {
    username = "mlardeur";
    homeDirectory = "/var/home/mlardeur";
    stateVersion = "24.11";

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
