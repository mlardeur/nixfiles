{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    musescore
    wireplumber
    helvum
    bitwig-studio
    vital
  ];

}
