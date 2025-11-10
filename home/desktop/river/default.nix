{ pkgs, config, lib, ... }:

let
  # Actually choose between rivertile and wideriver
  layout = "wideriver";

  # Elevate 2 to the exponent given as an argument 
  pow2 =
    let
      pow' = exponent: value:
        if exponent == 0
        then 1
        else if exponent <= 1
        then value
        else (pow' (exponent - 1) (value * 2));
    in
    exponent: pow' exponent 2;

  # Scratch Pad 
  scratchTag = pow2 20;
  # Sticky Tag
  stickyTag = pow2 31;
  allButMiscTag = 2146959359; # calculated for 20 with $(( ((1 << 32) - 1) ^ 20 ^ 32))

  # 0-9 Tag management
  tagsMap = lib.listToAttrs
    (lib.concatMap
      (i:
        let
          tag = (pow2 (i - 1));
        in
        [
          { name = "$mod1 ${toString i}"; value = "set-focused-tags ${toString (tag + stickyTag)}"; } # $mod1+[1-9] to focus tag [0-8]
          { name = "$mod1+Shift ${toString i}"; value = "set-view-tags ${toString tag}"; } # $mod1+Shift+[1-9] to tag focused view with tag [0-8]
          { name = "$mod1+Control ${toString i}"; value = "toggle-focused-tags ${toString tag}"; } # $mod1+Control+[1-9] to toggle focus of tag [0-8]
          { name = "$mod1+Shift+Control ${toString i}"; value = "toggle-view-tags ${toString tag}"; } # $mod1+Shift+Control+[1-9] to toggle tag [0-8] of focused view
        ])
      (lib.range 1 9));

  # Key map specific to the layout generator
  layoutMap =
    if layout == "rivertile" then {
      # $mod1+{Up,Right,Down,Left} to change layout orientation
      "$mod1+Shift Up" = "send-layout-cmd rivertile \"main-location top\"";
      "$mod1+Shift Right" = "send-layout-cmd rivertile \"main-location right\"";
      "$mod1+Shift Down" = "send-layout-cmd rivertile \"main-location bottom\"";
      "$mod1+Shift Left" = "send-layout-cmd rivertile \"main-location left\"";
      # $mod1+H and $mod1+L to decrease/increase the main ratio of rivertile(1)
      "$mod1 H" = "send-layout-cmd rivertile \"main-ratio -0.05\"";
      "$mod1 L" = "send-layout-cmd rivertile \"main-ratio +0.05\"";
      # $mod1+Shift+H and $mod1+Shift+L to increment/decrement the main count of rivertile(1)
      "$mod1+Shift H" = "send-layout-cmd rivertile \"main-count +1\"";
      "$mod1+Shift L" = "send-layout-cmd rivertile \"main-count -1\"";
    }
    else if layout == "wideriver" then {
      "$mod1+Shift Up" = "send-layout-cmd wideriver \"--layout monocle\"";
      "$mod1+Shift Down" = "send-layout-cmd wideriver \"--layout wide\"";
      "$mod1+Shift Left" = "send-layout-cmd wideriver \"--layout left\"";
      "$mod1+Shift Right" = "send-layout-cmd wideriver \"--layout right\"";
      "$mod1 Space" = "send-layout-cmd wideriver \"--layout-toggle\"";
      "$mod1 L" = "send-layout-cmd wideriver \"--ratio +0.05\"";
      "$mod1 H" = "send-layout-cmd wideriver \"--ratio -0.05\"";
      "$mod1+Shift H" = "send-layout-cmd wideriver \"--count +1\"";
      "$mod1+Shift L" = "send-layout-cmd wideriver \"--count -1\"";
      "$mod1 e" = "send-layout-cmd wideriver \"--stack even\"";
      "$mod1 w" = "send-layout-cmd wideriver \"--stack dwindle\"";
      "$mod1 i" = "send-layout-cmd wideriver \"--stack diminish\"";
    }
    else { };

  # Main command to start the layout generator
  layoutCommand =
    if layout == "rivertile" then ''
      rivertile -view-padding 4 -outer-padding 4 &
    ''
    else if layout == "wideriver" then "
    wideriver \\
    --layout                       right       \\
    --layout-alt                   wide        \\
    --stack                        even        \\
    --count-master                 1           \\
    --ratio-master                 0.50        \\
    --count-wide-left              1           \\
    --ratio-wide                   0.50        \\
    --smart-gaps                               \\
    --inner-gaps                   6           \\
    --outer-gaps                   2           \\
    --border-width                 1           \\
    --border-width-monocle         0           \\
    --border-width-smart-gaps      0           \\
    --border-color-focused         \"0x${config.colorScheme.palette.base0E}\"  \\
    --border-color-focused-monocle \"0x${config.colorScheme.palette.base0E}\"  \\
    --border-color-unfocused       \"0x${config.colorScheme.palette.base00}\"  \\
    --log-threshold                info        > \"/tmp/wideriver.\${XDG_VTNR}.\${USER}.log\" 2>&1 &
  "
    else "";

in
{
  home.packages = with pkgs; [
    wbg
    kanshi
    wideriver
  ];

  wayland.windowManager.river = {
    enable = true;
    extraSessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      mod1 = "Super";
    };
    settings = {
      border-width = 1;
      map = {
        normal = {
          # Note: the "$mod1" modifier is also known as Logo, GUI, Windows, Mod4, etc.
          "$mod1+Shift Return" = "spawn kitty";
          "$mod1 Q" = "close";
          "$mod1 C" = "close";
          "$mod1+Shift E" = "exit";
          # $mod1+J and $mod1+K to focus the next/previous view in the layout stack
          "$mod1 J" = "focus-view next";
          "$mod1 K" = "focus-view previous";
          "$mod1+Shift J" = "swap next";
          "$mod1+Shift K" = "swap previous";
          # $mod+left/right/up/down to focus the left/righ/up/down view in the layout stack
          "$mod1 Left" = "focus-view left";
          "$mod1 Right" = "focus-view right";
          "$mod1 Up" = "focus-view up";
          "$mod1 Down" = "focus-view down";
          # $mod1+Return to bump the focused view to the top of the layout stack
          "$mod1 Return" = "zoom";
          # $mod1+Alt+{H,J,K,L} to move views
          "$mod1+Alt H" = "move left 100";
          "$mod1+Alt J" = "move down 100";
          "$mod1+Alt K" = "move up 100";
          "$mod1+Alt L" = "move right 100";
          # $mod1+Alt+Control+{H,J,K,L} to snap views to screen edges
          "$mod1+Alt+Control H" = "snap left";
          "$mod1+Alt+Control J" = "snap down";
          "$mod1+Alt+Control K" = "snap up";
          "$mod1+Alt+Control L" = "snap right";
          # $mod1+Alt+Shift+{H,J,K,L} to resize views
          "$mod1+Alt+Shift H" = "resize horizontal -100";
          "$mod1+Alt+Shift J" = "resize vertical 100";
          "$mod1+Alt+Shift K" = "resize vertical -100";
          "$mod1+Alt+Shift L" = "resize horizontal 100";
          # Manage view
          "$mod1+Shift Space" = "toggle-float";
          "$mod1 F" = "toggle-fullscreen";
          # Toggle the scratchpad with Super+P
          "$mod1 P" = "toggle-focused-tags ${toString scratchTag}";
          # Send windows to the scratchpad with Super+Shift+P
          "$mod1+Shift P" = "set-view-tags ${toString scratchTag}";
          # Toggle the sticky tag with Super+S
          "$mod1 S" = "toggle-view-tags ${toString stickyTag}";
          # App specific Keymap use spawn
          "$mod1 N" = "spawn thunar";
          # Drun with rofi
          "$mod1 D" = "spawn 'rofi -show drun -show-icons'";
          # Control pulse audio volume with pactl)
          "None XF86AudioRaiseVolume" = "spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.0'";
          "None XF86AudioLowerVolume" = "spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-'";
          "None XF86AudioMute" = "spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";
          # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
          "None XF86AudioMedia" = "spawn 'playerctl play-pause'";
          "None XF86AudioPlay" = "spawn 'playerctl play-pause'";
          "None XF86AudioPrev" = "spawn 'playerctl previous'";
          "None XF86AudioNext" = "spawn 'playerctl next'";
          # Screenshot with grim and slurp (zone selection) 
          # TODO fix $(slurp)
          #"$mod1 Print" = "spawn \"grim -g \\\"$(slurp)\\\" $XDG_PICTURES_DIR/Screenshots/$(date +'%s.png')\"";
          "Print" = "spawn \"slurp | grim -g $XDG_PICTURES_DIR/Screenshots/$(date +'%s.png')\"";
        } // tagsMap // layoutMap;
      };
      map-pointer = {
        normal = {
          # Mouse interaction
          "$mod1 BTN_LEFT" = "move-view";
          "$mod1 BTN_RIGHT" = "resize-view";
          "$mod1 BTN_MIDDLE" = "toggle-float";
        };
      };
      focus-follows-cursor = "normal";
      spawn = [
        "waybar"
      ];
      spawn-tagmask = toString allButMiscTag;
      rule-add = [
        "ssd"
        "-app-id pavucontrol float"
      ];
      default-attach-mode = "below";
      default-layout = layout; # rivertile, wideriver, ... 
      set-repeat = "50 300";
      border-color-focused = "0x${config.colorScheme.palette.base0E}";
    };
    extraConfig = "
      # Set Keyboard Layout
      riverctl keyboard-layout -variant \"altgr-intl\" \"us\" &
      # Set wallpaper
      wbg \${XDG_PICTURES_DIR}/Wallpapers/montain-art-ultrawide.jpg &
      ${layoutCommand}
    ";

  };
}
