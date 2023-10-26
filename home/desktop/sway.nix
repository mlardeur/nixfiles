{ pkgs, ... }:

{
  home.packages = with pkgs; [
    autotiling
  ];

  wayland.windowManager.sway = {
    enable = true;
  };

  home.file = {
    ".config/sway" = {
      source = ./sway;
      recursive = true;
    };
  };

}
