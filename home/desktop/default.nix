{ pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./rofi.nix
    ./gtk.nix
    ./sway.nix
    ./waybar.nix
    #    ./hyprland.nix
  ];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # System
    pavucontrol
    playerctl
    networkmanagerapplet

    # General
    brave
    firefox-wayland
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin

    # Security
    authy
    bitwarden

    # Multimedia
    tidal-hifi
    spotify
    jellyfin-media-player

  ];

  # Music and media player 
  programs.mpv = {
    enable = true;
  };
  programs.ncmpcpp = {
    enable = true;
  };

  services = {
    mpd = {
      enable = true;
    };

    # Applets, shown in tray
    # Networking
    network-manager-applet.enable = true;
  };
}
