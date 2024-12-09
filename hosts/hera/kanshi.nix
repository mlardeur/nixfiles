{

  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "dell-ultrawide";
          outputs = [
            {
              criteria = "DP-1";
              mode = "3140x1440@100Hz";
            }
          ];
        };
      }
    ];
  };

}
