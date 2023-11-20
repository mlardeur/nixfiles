{ config, pkgs, ... }:
{

  services.dunst = {
    enable = true;
    settings = {
      global = {
        origin = "bottom-right";
        transparency = 10;
        font = "Droid Sans 9";
      };
    };
  };

}
