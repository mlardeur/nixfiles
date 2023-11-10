{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ../../home/cli
    ../../home/cli/beets.nix
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
    ];
  };

  targets.genericLinux.enable = true;
  xdg.mime.enable = true;


  xdg.userDirs = {
    enable = true;
    music = "/mnt/media/music";
  };

  programs.home-manager.enable = true;
}
