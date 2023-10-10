{ pkgs, ... }:

{
  imports = [
    ./sway.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    kitty
    foot
    rofi-wayland
  ];

}
