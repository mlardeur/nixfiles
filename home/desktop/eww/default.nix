{ pkgs, inputs, ... }:

{
  programs.eww = {
    enable = true;
    package = pkgs.eww;
    #configDir = ./config;
  };
}