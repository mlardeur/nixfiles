{ pkgs, ... }:
{

  # Using Flatpaks
  services.flatpak.packages = [
    { appId = "com.valvesoftware.Steam"; origin = "flathub"; }
    # { appId = "net.davidotek.pupgui2"; origin = "flathub"; }
    # { appId = "net.lutris.Lutris"; origin = "flathub"; }
    # { appId = "com.usebottles.bottles"; origin = "flathub"; }
  ];

  programs.mangohud = {
    enable = true;
  };

  home.packages = with pkgs; [
    radeontop
  ];
}
