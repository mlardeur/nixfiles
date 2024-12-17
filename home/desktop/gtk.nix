{ pkgs, ... }:
{
  gtk = {
    enable = true;
    font = {
      package = pkgs.noto-fonts-lgc-plus;
      name = "Noto Sans 10";
    };
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    cursorTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };
  };
}
