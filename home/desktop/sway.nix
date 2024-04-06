{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    autotiling
    swaybg
    swayidle
    kanshi
  ];

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    systemd.xdgAutostart = true;
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
        "2" = [{ app_id = "Chromium"; } { app_id = "Brave-browser"; }];
        "5" = [{ app_id = "firefox"; }];
      };
      bars = [{ command = "waybar"; }];
      input = {
        "type:keyboard" = {
          xkb_layout = "fr,us";
          xkb_variant = ",altgr-intl";
        };
        "16700:8453:Dell_Dell_USB_Keyboard" = {
          xkb_layout = "us";
          xkb_variant = "altgr-intl";
        };
      };
      startup = [
        { command = "autotiling"; always = true; }
        { command = "nm-applet --indicator"; always = true; }
      ];
    };
  };

  programs.swaylock = {
    enable = true;
  };

  services.swayidle = {
    enable = true;
  };

  home.file = {
    ".config/sway" = {
      source = ./sway;
      recursive = true;
    };
    "${config.xdg.userDirs.pictures}/Wallpapers/zen.png" = {
      source = ./Pictures/zen.png;
    };
  };

}
