{config , pkgs, ...}:

{
  imports = [
    ./git.nix 
  ];

  # Home Manger needs a bit of information about you and the 
  # paths is should manage.
  home.username = "maxime";
  home.homeDirectory = "/home/maxime";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    bitwarden
    vscode
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      startup = [
        
      ];
    };
  };
 
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
