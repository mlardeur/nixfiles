{ pkgs, inputs, ... }:

{

  # Allow insecure packages
  nixpkgs.config.allowUnfree = true;

  # Allow insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "electron-31.7.7"
  ];

  imports = [
    inputs.flatpaks.homeManagerModules.nix-flatpak
    ../cli/ncmpcpp.nix
    ./kitty.nix
    ./rofi.nix
    ./dunst.nix
    ./gtk.nix
    ./river
    ./sway.nix
    ./waybar.nix
    # ./hyprland.nix
  ];

  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    packages = [
      { appId = "dev.aunetx.deezer"; origin = "flathub"; }
      { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
    ];
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # System
    libnotify
    pavucontrol
    playerctl
    qdirstat
    gparted

    # General
    grim # Screenshot
    slurp # Screenshot
    brave
    firefox-wayland

    # Security
    bitwarden
    protonvpn-cli
    protonvpn-gui

    # Multimedia
    jellyfin-media-player
    feishin
  ];

  # Music and media player 
  programs = {
    mpv.enable = true;
    eww = {
      enable = true;
      configDir = ./eww;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "wlr"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [
          "gtk"
        ];
      };
      sway = {
        default = [
          "wlr"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [
          "gtk"
        ];
      };
    };
  };

  # MPD Music Player Daemon
  # services.mpd = {
  #     enable = true;
  #     network.listenAddress = "any";
  #   };
  # services.mpd-mpris.enable = true;

  # Applets, shown in tray
  # Networking
  # services.network-manager-applet.enable = true;

}
