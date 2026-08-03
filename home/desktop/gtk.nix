{ pkgs, ... }:
{
  gtk = {
    enable = true;
    colorScheme = "dark";
    font = {
      package = pkgs.noto-fonts-lgc-plus;
      name = "Noto Sans 10";
    };
    theme = {
      package = pkgs.yaru-remix-theme;
      name = "Yaru-remix-dark";
    };
    cursorTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };
}