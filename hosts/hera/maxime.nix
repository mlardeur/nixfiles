{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../home/cli
    ../../home/desktop
    ../../home/programs/dev.nix
    ../../home/programs/gaming.nix
    ../../home/programs/music.nix
    ./kanshi.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-terminal-dark;

  # Home Manger needs a bit of information about you and the 
  # paths is should manage.
  home = {
    username = "maxime";
    homeDirectory = "/home/maxime";
    stateVersion = "24.11";

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
    ];
  };

  xdg.userDirs = {
    enable = true;
    music = "/mnt/nebula/music";
  };

  programs.bash = {
    initExtra = ''
      if [[ $TTY == /dev/tty1 ]]; then
        exec sway
      fi
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
