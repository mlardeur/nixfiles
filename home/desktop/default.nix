{ pkgs, ... }:

{
  imports = [
    ./sway.nix
    ./waybar.nix
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    nixgl.nixGLIntel
    kitty
    foot
    rofi-wayland
  ];

}
