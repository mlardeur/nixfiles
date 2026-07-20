{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    musescore
    wireplumber
    crosspipe
    vital
    vcv-rack
    bitwig-studio
    yabridge
  ];

  services.flatpak.packages = [
    { appId = "com.bitwig.BitwigStudio"; origin = "flathub"; }
  ];


}
