{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ./cli
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "zion";
    homeDirectory = "/home/zion";
    stateVersion = "23.05";

    packages = with pkgs; [
      gnome.gnome-session
      budgie.budgie-desktop
    ];
  };

  programs.home-manager.enable = true;
}
