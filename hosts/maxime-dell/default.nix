{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ../../home/cli
    ../../home/cli/beets.nix
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

  programs.beets = {
    settings = {
      directory = "/mnt/zion/music";
      library = "/mnt/zion/music/libary.db";
    };
  };

  programs.home-manager.enable = true;
}
