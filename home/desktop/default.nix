{ pkgs, ... }:

{
  imports = [
    ./sway.nix
    ./waybar.nix
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    kitty
    foot
    rofi-wayland
  ];

}
