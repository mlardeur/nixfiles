{ inputs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;

    # Declarative settings, rendered to ~/.config/noctalia/config.toml.
    # Exported from the live session via `noctalia config export` (merged
    # user config = hand-written layer + Settings app overrides).
    # Anything still changed in the in-shell Settings app
    # (~/.local/state/noctalia/settings.toml) overrides these at runtime,
    # so delete that file after a successful switch to stay purely declarative.
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Tokyo-Night";
        # Remembered selection, only active when source = "community_palette".
        community_palette = "Tokyo Night Moon";
        wallpaper_scheme = "m3-rainbow";
      };

      # Noctalia owns the wallpaper (wbg was removed from the river init).
      wallpaper = {
        enabled = true;
        default.path = "/home/maxime/Pictures/Wallpapers/montain-art-ultrawide.jpg";
        last.path = "/home/maxime/Pictures/Wallpapers/montain-art-ultrawide.jpg";
        monitors."HDMI-A-2".path = "/home/maxime/Pictures/Wallpapers/montain-art-ultrawide.jpg";
      };

      bar.default = {
        background_opacity = 0.91;
        contact_shadow = true;
        start = [ "launcher" "workspaces" "media" ];
        end = [ "volume" "notifications" "clipboard" "network" "tray" "wallpaper" "session" ];
      };

      control_center = {
        width = 850;
        hidden_tabs = [ "monitor" "power" "bluetooth" ];
      };

      calendar.enabled = true;

      location.address = "Montpellier, France";

      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = [ "lockscreen-login-box@HDMI-A-2" ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget."lockscreen-login-box@HDMI-A-2" = {
          type = "login_box";
          output = "HDMI-A-2";
          cx = 1720.0;
          cy = 1258.0;
          box_width = 810.0;
          box_height = 196.0;
          placement_width = 3440.0;
          placement_height = 1440.0;
          rotation = 0.0;
          settings = {
            layout = "regular";
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 12.0;
            input_opacity = 1.0;
            input_radius = 6.0;
            center_password_text = false;
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
        };
      };
    };
  };
}
