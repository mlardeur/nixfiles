{ pkgs, ... }:

{
  programs.rofi ={
    enable = true;
    package = pkgs.rofi-wayland;
    cycle = false;
    terminal = "kitty";
    theme = "Arc-Dark";
    font = "Hack 11";
  };
}