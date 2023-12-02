{ pkgs, ... }:
{
  programs.ncmpcpp = {
    enable = true;
    settings = {
      media_library_primary_tag = "album_artist";
      execute_on_song_change = "\"notify-send -i \"\${XDG_MUSIC_DIR}/$(ncmpcpp -q --current-song {%D})/cover.jpg\" \"$(ncmpcpp -q --current-song {%A})\" \"$(ncmpcpp -q --current-song \"%b - %t\" 2>/dev/null)\"\"";
    };
  };

  services = {
    mpd = {
      enable = true;
      network.listenAddress = "any";
    };
    mpd-mpris.enable = true;
  };
}
