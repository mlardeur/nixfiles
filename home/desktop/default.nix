{ pkgs, inputs, ... }:

{

  imports = [
    inputs.flatpaks.homeManagerModules.nix-flatpak
    ./kitty.nix
    ./foot.nix
    ./rofi.nix
    ./quickshell.nix
    ./dunst.nix
    ./gtk.nix
    ./river
    ./waybar.nix
  ];

  home.pointerCursor = {
    enable = true;
    name = "Adwaita"; # or "Adwaita", "Capitaine Cursors", etc.
    package = pkgs.adwaita-icon-theme; # replace with the correct package
    gtk.enable = true; # apply to GTK applications too
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # System
    libnotify
    pavucontrol
    playerctl
    mpv

    # Windows emulation
    wine-wayland

    # General
    grim # Screenshot
    slurp # Screenshot
    kooha # Screen recorder
  ];

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

}
