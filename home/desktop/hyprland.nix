{ pkgs, ... }:

{

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    settings = {
      "$mod" = "SUPER";

      exec-once = [
        "waybar"
        "quickshell"
      ];

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;

        layout = "master";
        no_gaps_when_only = 1;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        # allow_tearing = false;
      };

      master = {
        mfact = 0.50;
        orientation = "right";
        always_center_master = false;
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = false;
      };

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, C, killactive,"
        "$mod SHIFT, E, exec, quickshell ipc call powermenu toggle"
        "$mod, N, exec, thunar"
        "$mod SHIFT, SPACE, togglefloating,"
        "$mod SHIFT, F, fullscreen,"
        "$mod, D, exec, quickshell ipc call launcher toggle"

        # Master layout controls (match river wideriver)
        "$mod, H, layoutmsg, mfact -0.05"
        "$mod, L, layoutmsg, mfact +0.05"
        "$mod SHIFT, H, layoutmsg, addmaster"
        "$mod SHIFT, L, layoutmsg, removemaster"
        "$mod, J, layoutmsg, cyclenext"
        "$mod, K, layoutmsg, cycleprev"
        "$mod SHIFT, J, layoutmsg, swapwithmaster"

        # Move focus with mod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Change master orientation with mod + shift + arrow keys (matches river)
        "$mod SHIFT, left, layoutmsg, orientationleft"
        "$mod SHIFT, right, layoutmsg, orientationright"
        "$mod SHIFT, up, layoutmsg, orientationtop"
        "$mod SHIFT, down, layoutmsg, orientationbottom"

        # Move window with mod + alt + hjkl (matches river)
        "$mod ALT, H, movewindow, l"
        "$mod ALT, J, movewindow, d"
        "$mod ALT, K, movewindow, u"
        "$mod ALT, L, movewindow, r"

        # Resize window with mod + alt + shift + hjkl (matches river)
        "$mod ALT SHIFT, H, resizeactive, -20 0"
        "$mod ALT SHIFT, J, resizeactive, 0 20"
        "$mod ALT SHIFT, K, resizeactive, 0 -20"
        "$mod ALT SHIFT, L, resizeactive, 20 0"

        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ];
    };
  };

}

