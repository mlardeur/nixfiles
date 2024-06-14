{

  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "laptop";
          outputs = [
            {
              criteria = "eDP-1";
            }
          ];
        };
      }
      {
        profile = {
          name = "hdmi";
          outputs = [
            {
              criteria = "eDP-1";
              position = "0,1080";
            }
            {
              criteria = "DP-3";
              mode = "1920x1080";
              position = "0,0";
            }
          ];
        };
      }
      {
        profile = {
          name = "usb-c";
          outputs = [
            {
              criteria = "eDP-1";
              scale = 1.0;
              position = "320,1440";
            }
            {
              criteria = "DP-1";
              mode = "2560x1440";
              position = "0,0";
            }
          ];
        };
      }
    ];
  };
}
