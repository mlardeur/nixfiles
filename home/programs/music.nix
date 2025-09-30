{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    musescore
    wireplumber
    helvum
    vital
  ];

  services.flatpak.packages = [
    { appId = "com.bitwig.BitwigStudio"; origin = "flathub"; }
  ];


}
