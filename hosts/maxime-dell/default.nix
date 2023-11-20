{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../home/cli
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

  home.sessionVariables = {
    GIO_EXTRA_MODULES = "/usr/share/lib/gio/modules";
  };

  targets.genericLinux.enable = true;
  xdg.mime.enable = true;

  xdg.userDirs = {
    enable = true;
    music = "/mnt/zion/music";
  };

  programs.home-manager.enable = true;
}
