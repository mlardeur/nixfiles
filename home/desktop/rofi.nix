{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    cycle = false;
    terminal = "kitty";
    theme = "Arc-Dark";
    font = "Hack 11";
  };

  home.file = {
    ".config/rofi" = {
      source = ./rofi;
      recursive = true;
    };
  };
}
