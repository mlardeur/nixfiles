{ config, pkgs, ... }:

{
  programs.beets = {
    enable = true;
    settings = {
      directory = "${config.xdg.userDirs.music}";
      library = "${config.xdg.userDirs.music}/library.db";
      ui.color = true;
      import = {
        move = true;
        resume = true;
        incremental = true;
        log = "beets.log";
      };
      plugins = [
        "fetchart"
        "smartplaylist"
        "embedart"
        "acousticbrainz"
        "spotify"
      ];
    };
  };
}
