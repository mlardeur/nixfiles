{ pkgs, inputs, ... }:

{
  programs.eww = {
    enable = true;
    package = pkgs.eww;
    enableFishIntegration = true;
    #configDir = ./config;
  };
}