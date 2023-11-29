{

  services.kanshi = {
    enable = true;
    profiles = {
      laptop = {
        outputs = [
          {
            criteria = "DP-1";
            mode = "2560x1440@69.923Hz";
          }
        ];
      };
    };
  };

}