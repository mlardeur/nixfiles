{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    swaybg
    wbg
    kanshi
  ];

  wayland.windowManager.river = {
    enabled = true;
  };
}