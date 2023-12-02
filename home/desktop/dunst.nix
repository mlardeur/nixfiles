{ config, pkgs, ... }:
{

  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 330;
        height = 300;
        corner_radius = 10;
        offset = "30x30";
        origin = "bottom-right";
        transparency = 10;
        font = "Droid Sans 10";
        frame_width = 2;
        foreground = "#${config.colorScheme.colors.base05}";
        background = "#${config.colorScheme.colors.base00}";
      };
    };
  };

}
