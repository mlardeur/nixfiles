{ pkgs, ... }:

{
  imports = [
    ../cli/ncmpcpp.nix
    ./kitty.nix
    ./rofi.nix
    ./dunst.nix
    ./gtk.nix
    ./sway.nix
    ./waybar.nix
    #    ./hyprland.nix
  ];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # System
    libnotify
    pavucontrol
    playerctl
    networkmanagerapplet

    # General
    brave
    firefox-wayland

    # Security
    authy
    bitwarden
    protonvpn-gui

    # Multimedia
    tidal-hifi
    spotify
    jellyfin-media-player

  ];

  # Music and media player 
  programs.mpv = {
    enable = true;
  };

  services = {
    mpd = {
      enable = true;
      network.listenAddress = "any";
    };
    mpd-mpris.enable = true;

    # Applets, shown in tray
    # Networking
    network-manager-applet.enable = true;
  };
}
