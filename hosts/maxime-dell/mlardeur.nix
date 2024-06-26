{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    ../../home/cli
    ../../home/programs/dev.nix
    ../../home/programs/datasciences.nix
    ../../home/programs/gaming.nix
    ../../home/desktop
    ./kanshi.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-terminal-dark;

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
