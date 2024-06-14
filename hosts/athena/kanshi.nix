{

  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "iiyama";
          outputs = [
            {
              criteria = "DP-1";
              mode = "2560x1440@69.923Hz";
            }
          ];
        };
      }
    ];
  };

}
