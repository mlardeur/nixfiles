{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ./cli
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

  programs.beets = {
    settings = {
      directory = "/mnt/media/music";
      library = "/mnt/media/music/libary.db";
    };
  };

  programs.home-manager.enable = true;
}
