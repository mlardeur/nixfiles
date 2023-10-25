{ config, pkgs, ... }:

{
  imports = [
    ../../home/cli
    ../../home/programs
    ../../home/desktop
    ../../home/programs/dev.nix 
  ];

  # Home Manger needs a bit of information about you and the 
  # paths is should manage.
  home = {
    username = "maxime";
    homeDirectory = "/home/maxime";
    stateVersion = "23.05";

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
    ];
  };



  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
