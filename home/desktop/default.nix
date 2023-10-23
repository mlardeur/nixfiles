{ pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./rofi.nix
    ./sway.nix
    ./waybar.nix
    ./hyprland.nix
  ];

  gtk = {
    enable = true;
    font = {
      package = pkgs.noto-fonts;
      name = "Noto Sans 10";
    };
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    cursorTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc-X-D";
    };    
  };

}
