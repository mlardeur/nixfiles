{ config, inputs, lib, ... }:

let
  mod = "SUPER";

  # river tagsMap equivalent: mango uses tag numbers directly (1-9).
  # $mod1+[1-9] focus tag, Shift move view to tag, Ctrl toggle view,
  # Shift+Ctrl toggle tag of focused view.
  tagBinds = lib.concatMap (i: [
    "${mod},${toString i},view,${toString i}"
    "${mod}+SHIFT,${toString i},tag,${toString i}"
    "${mod}+CTRL,${toString i},toggleview,${toString i}"
    "${mod}+SHIFT+CTRL,${toString i},toggletag,${toString i}"
  ]) (lib.range 1 9);

  # All tags default to the river/wideriver "right" layout (master right).
  tagRules = map (i: "id:${toString i},layout_name:right_tile") (lib.range 1 9);

  # Noctalia v5 IPC (replaces the quickshell ipc calls in the river config).
  shellCmd = cmd: "spawn,noctalia msg ${cmd}";
in
{
  imports = [ inputs.mangowm.hmModules.mango ];

  wayland.windowManager.mango = {
    enable = true;

    autostart_sh = ''
      noctalia &
      lxqt-policykit-agent &
    '';

    settings = {
      # river extraSessionVariables equivalent.
      env = [ "MOZ_ENABLE_WAYLAND,1" ];

      # river set-repeat 50 300 + keyboard-layout -variant altgr-intl us
      repeat_rate = 50;
      repeat_delay = 300;
      xkb_rules_layout = "us";
      xkb_rules_variant = "altgr-intl";

      # river focus-follows-cursor normal (no pointer warping).
      sloppyfocus = 1;
      warpcursor = 0;

      # Wideriver parity: right master, even stack, 1 master at 0.5,
      # new windows attached below the master (river default-attach-mode below).
      default_nmaster = 1;
      default_mfact = 0.5;
      new_is_master = 0;
      # Mod+Space layout-toggle equivalent (right master <-> wide).
      circle_layout = "right_tile,vertical_tile";

      # wideriver --inner-gaps 6 --outer-gaps 2 --smart-gaps --border-width 1
      gappih = 6;
      gappiv = 6;
      gappoh = 2;
      gappov = 2;
      smartgaps = 1;
      borderpx = 1;
      border_radius = 0;
      bordercolor = "0x${config.colorScheme.palette.base00}ff";
      focuscolor = "0x${config.colorScheme.palette.base0E}ff";

      # Noctalia docs recommendation: keep window blur/shadows but let the
      # shell render its own for layer surfaces (layer_shadows=0 avoids a
      # double shadow under Noctalia's self-rendered bar/dock/panel shadows).
      # Values follow https://docs.noctalia.dev/noctalia/compositor-settings/mango/.
      blur = 1;
      blur_layer = 0;
      blur_optimized = 1;
      blur_params_num_passes = 2;
      blur_params_radius = 5;
      blur_params_noise = 0.02; # mango default (explicit per doc)
      blur_params_brightness = 0.9; # mango default (explicit per doc)
      blur_params_contrast = 0.9; # mango default (explicit per doc)
      blur_params_saturation = 1.0; # doc value (mango default is 1.2)
      layer_animations = 0; # mango default (explicit per doc)

      shadows = 1;
      layer_shadows = 0; # Noctalia draws its own shadows for layer surfaces
      shadow_only_floating = 0; # doc value (mango default 1 = no tiled shadow)
      shadows_size = 4; # doc value (mango default 10)
      shadows_blur = 12; # doc value (mango default 15)
      shadows_position_x = 2; # doc value (mango default 0)
      shadows_position_y = 2; # doc value (mango default 0)
      shadowscolor = "0x000000ff"; # mango default (explicit per doc)

      # Animations: no slide when switching the activated workspace/tag, and
      # no transition when a window closes (applies to floating + tiled).
      # mango clamps animation_duration_* to >= 1 ms, so 1 = effectively off;
      # animation_type_close="none" removes the close transition outright.
      animation_duration_tag = 1;
      animation_type_close = "none";

      tagrule = tagRules;

      # river rule-add: -app-id pavucontrol float
      # Noctalia's own dialogs should never be tiled.
      windowrule = [
        "isfloating:1,appid:pavucontrol"
        "isfloating:1,appid:dev.noctalia.Noctalia"
        "isfloating:1,appid:dev.noctalia.UmbrielSharePicker"
      ];

      bind = [
        # Applications (river: $mod1+Shift Return / N / D / Shift E)
        "${mod}+SHIFT,Return,spawn,kitty"
        "${mod},n,spawn,thunar"
        "${mod},d,${shellCmd "panel-toggle launcher"}"
        "${mod}+SHIFT,e,${shellCmd "panel-toggle session"}"

        # Close (river: $mod1 Q / C)
        "${mod},q,killclient"
        "${mod},c,killclient"

        # Focus / swap in stack (river: $mod1 J/K, $mod1+Shift J/K)
        "${mod},j,focusstack,next"
        "${mod},k,focusstack,prev"
        "${mod}+SHIFT,j,exchange_stack_client,next"
        "${mod}+SHIFT,k,exchange_stack_client,prev"

        # Directional focus (river: $mod1 arrows)
        "${mod},Left,focusdir,left"
        "${mod},Right,focusdir,right"
        "${mod},Up,focusdir,up"
        "${mod},Down,focusdir,down"

        # Bump focused window to master (river: $mod1 Return -> zoom)
        "${mod},Return,zoom"

        # Move floating windows (river: $mod1+Alt {H,J,K,L}, 100px steps)
        "${mod}+ALT,h,movewin,-100,0"
        "${mod}+ALT,j,movewin,0,100"
        "${mod}+ALT,k,movewin,0,-100"
        "${mod}+ALT,l,movewin,100,0"

        # Snap floating windows to edges (river: $mod1+Alt+Control {H,J,K,L})
        "${mod}+ALT+CTRL,h,smartmovewin,left"
        "${mod}+ALT+CTRL,j,smartmovewin,down"
        "${mod}+ALT+CTRL,k,smartmovewin,up"
        "${mod}+ALT+CTRL,l,smartmovewin,right"

        # Resize floating windows (river: $mod1+Alt+Shift {H,J,K,L})
        "${mod}+ALT+SHIFT,h,smartresizewin,left"
        "${mod}+ALT+SHIFT,j,smartresizewin,down"
        "${mod}+ALT+SHIFT,k,smartresizewin,up"
        "${mod}+ALT+SHIFT,l,smartresizewin,right"

        # Window state (river: toggle-float / toggle-fullscreen /
        # scratchpad tag / sticky tag)
        "${mod}+SHIFT,space,togglefloating"
        "${mod},f,togglefullscreen"
        "${mod},p,toggle_scratchpad"
        "${mod}+SHIFT,p,minimized"
        "${mod},s,toggleglobal"

        # Wideriver layout controls
        "${mod}+SHIFT,up,setlayout,monocle"           # --layout monocle
        "${mod}+SHIFT,down,setlayout,vertical_tile"   # --layout wide
        "${mod}+SHIFT,left,setlayout,tile"            # --layout left
        "${mod}+SHIFT,right,setlayout,right_tile"     # --layout right
        "${mod},space,switch_layout"                  # --layout-toggle
        "${mod},h,setmfact,-0.05"                     # --ratio -0.05
        "${mod},l,setmfact,+0.05"                     # --ratio +0.05
        "${mod}+SHIFT,h,incnmaster,+1"                # --count +1
        "${mod}+SHIFT,l,incnmaster,-1"                # --count -1
        "${mod},e,setlayout,tile"                     # --stack even
        "${mod},w,setlayout,dwindle"                  # --stack dwindle
        "${mod},i,setlayout,dwindle"                  # --stack diminish (closest match)

        # Media keys (river parity: direct wpctl/playerctl, no OSD binding)
        "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.0"
        "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
        "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "NONE,XF86AudioMedia,spawn,playerctl play-pause"
        "NONE,XF86AudioPlay,spawn,playerctl play-pause"
        "NONE,XF86AudioPrev,spawn,playerctl previous"
        "NONE,XF86AudioNext,spawn,playerctl next"

        # Screenshot (river Print binding, fixed: slurp geometry via grim -g -)
        "NONE,Print,spawn_shell,mkdir -p \"$HOME/Pictures/Screenshots\" && slurp | grim -g - \"$HOME/Pictures/Screenshots/$(date +%s).png\""

        # Exit
        "${mod}+SHIFT,q,quit"
      ] ++ tagBinds;

      # river map-pointer parity (BTN_MIDDLE kept as float toggle).
      mousebind = [
        "${mod},btn_left,moveresize,curmove"
        "${mod},btn_right,moveresize,curresize"
        "${mod},btn_middle,togglefloating"
      ];
    };
  };
}
