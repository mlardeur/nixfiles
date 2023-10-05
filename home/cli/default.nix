{pkgs, ...}: 

{
  imports = [
    ./git.nix
  ];

  programs.bat = {
    enable = true;
    config.theme = "base16";
  };

  programs.fish.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };  

  home.packages = with pkgs; [
    ranger
  ];
}
