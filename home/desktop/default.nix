{ pkgs, ... }:

{
  imports = [
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
    xdg-desktop-portal

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

  programs.ncmpcpp = {
    enable = true;
    settings = {
      media_library_primary_tag = "album_artist";
      execute_on_song_change = "\"notify-send -i \"\${XDG_MUSIC_DIR}/$(ncmpcpp -q --current-song {%D})/cover.jpg\" \"$(ncmpcpp -q --current-song {%A})\" \"$(ncmpcpp -q --current-song \"%b - %t\" 2>/dev/null)\"\"";
    };
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
