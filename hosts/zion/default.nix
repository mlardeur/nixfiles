{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../home/cli
    ../../home/desktop/kitty.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-terminal-dark;

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
