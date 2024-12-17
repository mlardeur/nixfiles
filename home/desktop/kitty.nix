{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "tokyo_night_night";
    font = {
      package = pkgs.nerd-fonts.hack; # Tested JetBrainsMono, FiraCode, DroidSansMono, Hack
      name = "Hack";
    };
    shellIntegration.enableFishIntegration = true;
    settings = {
      background_opacity = "0.85";
      confirm_os_window_close = 2;
      shell = "fish";
    };
  };
}
