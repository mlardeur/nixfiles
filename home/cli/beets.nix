{ pkgs, ...}:

{
  programs.beets = {
    enable = true;
    settings = {
      ui.color = true;
      import = {
        move = true;
        resume = true;
        incremental = true;
        log = "beets.log";
      };
    };
  };
}
