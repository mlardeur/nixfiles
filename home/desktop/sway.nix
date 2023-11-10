{ pkgs, ... }:

{
  home.packages = with pkgs; [
    autotiling
  ];

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    systemd.xdgAutostart = false;
    xwayland = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "rofi -show drun -show-icons";
      # rofi -show combi -modes combi -combi-modes "window,drun,run" -show-icons"
      gaps = {
        inner = 8;
        outer = 2;
        smartGaps = true;
      };
      assigns = {
        "2" = [{ app_id = "Chromium"; }];
        "5" = [{ app_id = "firefox"; }];
      };
      bars = [{ command = "waybar"; }];
      startup = [
        { command = "autotiling"; always = true; }
        { command = "nm-applet --indicator"; always = true; }
      ];
    };
  };

  home.file = {
    ".config/sway" = {
      source = ./sway;
      recursive = true;
    };
  };

}
