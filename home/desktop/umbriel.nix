{ config, inputs, pkgs, lib, ... }:

let
  # Wayland compositor by noctalia-dev, paired with the Noctalia shell.

  # Predefined workspaces: unscoped name entries materialize on every
  # dynamic output at startup and survive when empty, so the bar always
  # shows the same slots regardless of which monitor is connected.
  namedWorkspaces = map (i: { name = toString i; }) (lib.range 1 7);

  # 1-7 target the named workspaces by exact name (quoted selector);
  # 8-9 stay positional as dynamic overflow slots.
  tagBinds = lib.listToAttrs (lib.concatMap (i: [
    {
      name = "Mod+${toString i}";
      value = "workspace-switch:${if i <= 7 then "\"${toString i}\"" else toString i}";
    }
    {
      name = "Mod+Shift+${toString i}";
      value = "window-move-to-workspace:${if i <= 7 then "\"${toString i}\"" else toString i}";
    }
  ]) (lib.range 1 9));

  # app_id regex -> named workspace. Verify ids live with:
  #   umbriel windows --json | jq -r '.[] | "\(.app_id)  \(.title)"'
  appWorkspaceRules = [
    { match = "^brave-browser$"; workspace = "2"; }
    { match = "^com\\.jetbrains\\.WebStorm$"; workspace = "3"; }
    { match = "^jetbrains-idea.*$"; workspace = "4"; }
    { match = "^firefox$"; workspace = "5"; }
    { match = "^(code|Code)$"; workspace = "6"; }
    { match = "^jetbrains-datagrip.*$"; workspace = "6"; }
    { match = "^dev\\.aunetx\\.deezer$"; workspace = "7"; }
  ];
  appRules = map (r: {
    match.app_id = r.match;
    default_workspace = r.workspace;
  }) appWorkspaceRules;

in
{
  imports = [ inputs.umbriel.homeModules.default ];

  programs.umbriel = {
    enable = true;

    settings = {
      general = {
        # river init spawns: noctalia (shell/bar) + lxqt-policykit-agent.
        # xwayland-satellite is auto-spawned by Umbriel (general.xwayland).
        autostart = [
          "noctalia"
          "lxqt-policykit-agent"
        ];
        show_cheatsheet = true;                         # Show the keybind overlay on startup
        focus_on_activate = false;                      # Do not let unsolicited requests steal focus
        honor_restored_maximize = false;                # Honor restored maximized state
      };

      # Mirrors river's extraSessionVariables.
      environment = {
        MOZ_ENABLE_WAYLAND = "1";
      };

      input = {
        keyboard = {
          layout = "us";
          variant = "altgr-intl";
          repeat_rate = 50;
          repeat_delay = 300;
        };
        focus.follows_mouse = true;
      };

      layout = {
        mode = "master";
        gap = 6;
        master = {
          position = "right";                             # left, right, or center master area
          default_width_fraction = 0.70;                  # Initial master area fraction, 0.1-0.9
          new_on_top = false;                             # Put new windows at the top of the stack
          new_becomes_master = false;                     # New windows take the master slot
        };
      };

      # Seven persistent named workspaces on every dynamic output.
      workspace = namedWorkspaces;

      animation = {
        # Instant workspace switches.
        workspaces.enabled = false;
      };

      # river: border-width 1, no rounded corners
      appearance = {
        prefer_no_csd = true ;                          # Prefer Umbriel's border-only decoration
        border_width = 2;                               # Inner border width, 0-100 logical pixels
        outer_border_width = 0;                         # Optional outer ring, 0-100 logical pixels
        corner_radius = 10;                             # Radius of the final decorated edge, 0-100
        drag_opacity = 0.75;                            # Window opacity during a tiled or floating drag
      };

      colors.border = {
        focused = "#${config.colorScheme.palette.base0E}FF";
        unfocused = "#${config.colorScheme.palette.base00}FF";
      };

      # A config file replaces Umbriel's built-in keybind set entirely,
      # so every chord that should exist must be listed here.
      keybinds = {
        # Applications (river: Mod+Shift Return / Mod N / Mod D / Mod+Shift Escape)
        "Mod+Shift+Return" = "spawn:kitty";
        "Mod+N" = "spawn:thunar";
        "Mod+D" = "spawn:noctalia msg panel-toggle launcher";
        "Mod+Shift+Escape" = "spawn:noctalia msg panel-toggle session";
        "Mod+Escape" = "session-quit";

        # Close / focus / swap (river: Mod Q, Mod C, Mod J/K, Mod+Shift J/K, arrows)
        "Mod+Q" = "window-close";
        "Mod+C" = "window-close";
        "Mod+J" = "window-focus-next";
        "Mod+K" = "window-focus-previous";
        "Mod+Shift+J" = "window-swap-next";
        "Mod+Shift+K" = "window-swap-previous";
        "Mod+Left" = "window-focus-left";
        "Mod+Right" = "window-focus-right";
        "Mod+Up" = "window-focus-up";
        "Mod+Down" = "window-focus-down";

        # Swap focused window with the top master row. Umbriel has no
        # swap-with-master action; with master position "right" the layout
        # ring is [stack..., master...], so swap-next exchanges the bottom
        # stack row (new_on_top = false puts new windows and focus there)
        # with master. Press Mod+Shift+K (swap-previous) from the raised
        # window to send it back and pull the old master up: a clean pair.
        "Mod+Return" = "window-swap-next";

        # Move windows (river: Mod+Alt {H,J,K,L})
        "Mod+Alt+H" = "column-move-left";
        "Mod+Alt+L" = "column-move-right";
        "Mod+Alt+J" = "window-move-down";
        "Mod+Alt+K" = "window-move-up";

        # Resize windows (river: Mod+Alt+Shift {H,J,K,L}, 100px -> 5% fractions)
        "Mod+Alt+Shift+H" = "window-modify-width:-0.05";
        "Mod+Alt+Shift+L" = "window-modify-width:0.05";
        "Mod+Alt+Shift+K" = "window-modify-height:-0.05";
        "Mod+Alt+Shift+J" = "window-modify-height:0.05";

        # Window state (river: Mod+Shift Space float, Mod F fullscreen,
        # Mod S sticky tag -> pinned on all workspaces)
        "Mod+Shift+Space" = "window-toggle-floating";
        "Mod+F" = "window-toggle-fullscreen";
        "Mod+S" = "window-toggle-pinned";
        "Mod+O" = "overview-toggle";

        # Scratchpad (river: Mod P toggle tag 21, Mod+Shift P send to it)
        "Mod+P" = "scratchpad-toggle";
        "Mod+Shift+P" = "window-move-to-scratchpad";
        "Mod+Ctrl+Space" = "window-restore-from-scratchpad";

        # Layout controls
        "Mod+Ctrl+T" = "workspace-set-layout:toggle";
        "Mod+H" = "window-modify-width:-0.05";
        "Mod+L" = "window-modify-width:0.05";
        "Mod+Shift+H" = "layout-master-count-increase";
        "Mod+Shift+L" = "layout-master-count-decrease";
        "Mod+Shift+Left" = "workspace-set-layout:master";
        "Mod+Shift+Down" = "workspace-set-layout:dwindle";
        "Mod+Shift+Up" = "window-toggle-maximize-to-edges";
        "Mod+Shift+Right" = "workspace-set-layout:scrolling";

        # Media keys (river parity)
        "XF86AudioRaiseVolume" = "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.0";
        "XF86AudioLowerVolume" = "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
        "XF86AudioMute" = "spawn:wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMedia" = "spawn:playerctl play-pause";
        "XF86AudioPlay" = "spawn:playerctl play-pause";
        "XF86AudioPrev" = "spawn:playerctl previous";
        "XF86AudioNext" = "spawn:playerctl next";

        # Screenshot (river Print binding, fixed: slurp geometry via grim -g -)
        "Print" = "spawn:mkdir -p \"$HOME/Pictures/Screenshots\" && slurp | grim -g - \"$HOME/Pictures/Screenshots/$(date +%s).png\"";
      } // tagBinds;

      window_rule = [
        # Global blur engine opt-in (upstream example).
        {
          blur = true;
          blur_optimized = false;
        }
        # river rule-add: -app-id pavucontrol float
        {
          match.app_id = "^pavucontrol$";
          default_floating = true;
        }
        # Noctalia shell dialogs (upstream example).
        {
          match.app_id = "^dev.noctalia.Noctalia$";
          default_floating = true;
          default_size = [ 1020 900 ];
        }
        {
          match.app_id = "^dev.noctalia.UmbrielSharePicker$";
          default_floating = true;
          default_size = [ 800 600 ];
        }
        {
          match.title = "^(Picture-in-Picture|Picture in picture)$";
          default_floating = true;
          default_maximize = false;
          default_position = {
            x = 20;
            y = 20;
            anchor = "bottom_right";
          };
        }
      ] ++ appRules;

      layer_rule = [
        {
          match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
          blur = true;
          blur_ignore_alpha = 0.5;
          blur_popups = true;
          blur_optimized = false;
        }
      ];
    };
  };

  # Umbriel spawns it itself when general.xwayland = true, but it must be on PATH.
  home.packages = [ pkgs.xwayland-satellite ];

  # Screencast/screenshot portal for Umbriel sessions (user space).
  # XDG_CURRENT_DESKTOP=Umbriel makes the per-desktop section override the
  # common wlr default; other sessions are untouched.
  xdg.portal = {
    extraPortals = [ inputs.umbriel.inputs.xdg-desktop-portal-umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    config.umbriel.default = [
      "umbriel"
      "gtk"
    ];
  };
}
