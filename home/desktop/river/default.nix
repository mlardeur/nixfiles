{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    swaybg
    wbg
    kanshi
  ];

  wayland.windowManager.river = {
    enable = true;
    settings = {
      map = {
        normal = {
          "Super+Shift Return" = "spawn kitty";
          "Super Q" = "close";
          "Super+Shift E" = "exit";
          "Super BTN_LEFT" = "move-view";
        };
      };
      spawn = [
        "waybar"
      ];
      default-layout = "rivertile";
    };
    extraConfig = "rivertile -view-padding 6 -outer-padding 6 &";

  };
}
