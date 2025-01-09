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
    userName = "Maxime Lardeur";
    userEmail = "max.lardeur@gmail.com";
  };
}
