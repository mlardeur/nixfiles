{
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      # Assign
      assigns = {
        "5" = [{ class = "^Firefox$"; }];
      };
      gaps = {
        smartBorders = "on";
        smartGaps = "on";
      };
      startup = [
        
      ];      
    };
  };
}