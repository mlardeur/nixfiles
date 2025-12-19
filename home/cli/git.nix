{ pkgs, ... }:

{

  home.packages = with pkgs; [
    # cli tools
    gitui
    gitflow
    git-lfs
    git-town
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "Maxime Lardeur";
      user.email = "max.lardeur@gmail.com";    
    };
  };
}
