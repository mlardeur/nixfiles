{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    godot
    blender
    pencil2d
    gimp
    krita
    inkscape
    aseprite
  ];

}
