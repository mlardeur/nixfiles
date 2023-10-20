{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ../../home/cli
    ../../home/programs
    ../../home/programs/dev.nix
    ../../home/programs/gaming.nix
    ../../home/desktop
    ./kanshi.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "mlardeur";
    homeDirectory = "/home/mlardeur";
    stateVersion = "23.05";

    packages = with pkgs; [
      nixgl.nixGLIntel
    ];
  };

  targets.genericLinux.enable = true;
  xdg.mime.enable = true;

  programs.home-manager.enable = true;
}
